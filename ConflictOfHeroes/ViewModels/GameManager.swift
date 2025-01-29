//
//  GameManager.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 04.12.24.
//

import Foundation
import GameKit

class GameManager: NSObject, ObservableObject, GKTurnBasedMatchmakerViewControllerDelegate {
    @Published var viewModel: GameViewModel
    @Published var cardDeck: CardDeck
    @Published var hitMarkerPool: HitMarkerPool
    @Published var match: GKTurnBasedMatch?

    init(cardDeck: CardDeck, hitMarkerPool: HitMarkerPool) {
        self.viewModel = GameViewModel()
        self.cardDeck = cardDeck
        self.hitMarkerPool = hitMarkerPool
    }

    private func loadMission(
        missionData: MissionData,
        customize: (inout [Card], inout [Card]) -> Void
    ) {
        resetGame()

        let mission = Mission(rawValue: missionData.gameSetup.name) ?? .mission1
        var (inGame, backUp, killed) = loadInitialUnits(for: mission, missionData: missionData)
        let containsArtillery = inGame.contains(where: { $0.units.contains { $0.name == "Artillery" } }) || backUp.contains { $0.name == "Artillery" } || killed.contains { $0.name == "Artillery" }

        if !containsArtillery {
            let tokenTypes: [String: Int] = [
                "Artillery": 1,
                "Barbed Wire": 8,
                "Bunkers": 8,
                "Hasty Defenses": 8,
                "Immobilized": 2,
                "Mines": 8,
                "Road Blocks": 8,
                "Smoke": 16,
                "Trenches": 8
            ]

            tokenTypes.forEach { tokenName, count in
                backUp.append(contentsOf: (0..<count).map { _ in
                    Unit(
                        name: tokenName,
                        army: .german,
                        exhausted: true,
                        statsDictionary: [:]
                    )
                })
            }
        }

        viewModel.missionData = missionData
        viewModel.gameState = missionData.gameState
        viewModel.inGameUnits = inGame
        viewModel.backUpUnits = backUp
        viewModel.killedUnits = killed

        customize(&viewModel.germanCards, &viewModel.sovietCards)
    }

    func loadSetupMission(missionData: MissionData) {
        loadMission(missionData: missionData) { germanCards, sovietCards in
            germanCards.append(contentsOf: missionData.gameState.germanCards.flatMap { code, count in
                cardDeck.drawNonRandomCards(code: code, count: count)
            })
            sovietCards.append(contentsOf: missionData.gameState.sovietCards.flatMap { code, count in
                cardDeck.drawNonRandomCards(code: code, count: count)
            })

            drawCards(for: &germanCards, number: missionData.gameSetup.card.german.startWith)
            drawCards(for: &sovietCards, number: missionData.gameSetup.card.soviet.startWith)
        }
    }

    private func removeAssignedHitMarkers() {
        for cell in viewModel.inGameUnits {
            for unit in cell.units {
                if let hitMarker = unit.hitMarker {
                    if let index = hitMarkerPool.pool.firstIndex(where: { $0.code == hitMarker.code }) {
                        hitMarkerPool.pool.remove(at: index)
                    }
                }
            }
        }
    }

    func loadSavedMission(missionData: MissionData) {
        loadMission(missionData: missionData) { germanCards, sovietCards in
            germanCards = missionData.gameState.germanCards.flatMap { code, count in
                cardDeck.drawNonRandomCards(code: code, count: count)
            }
            sovietCards = missionData.gameState.sovietCards.flatMap { code, count in
                cardDeck.drawNonRandomCards(code: code, count: count)
            }

            removeAssignedHitMarkers()
        }
    }

    func saveMission(to fileURL: URL) {
        guard let missionData = viewModel.missionData else {
            print("Error: No mission data to save.")
            return
        }

        var allGameUnits: [Unit] = []
        var GermanCards: [String: Int] = [:]
        var SovietCards: [String: Int] = [:]

        for cell in viewModel.inGameUnits {
            for unit in cell.units {
                let gameUnit = Unit(
                    name: unit.name,
                    army: unit.army,
                    hexagon: cell.offsetCoordinate,
                    orientation: unit.orientation,
                    exhausted: unit.exhausted,
                    hitMarker: unit.hitMarker,
                    stressed: unit.stressed,
                    state: .inGame,
                    statsDictionary: [:]
                )
                allGameUnits.append(gameUnit)
            }
        }

        for unit in viewModel.backUpUnits {
            let gameUnit = Unit(
                name: unit.name,
                army: unit.army,
                hexagon: HexagonCoordinate(row: 0, col: 0),
                orientation: unit.orientation,
                exhausted: unit.exhausted,
                hitMarker: unit.hitMarker,
                stressed: unit.stressed,
                state: .backUp,
                statsDictionary: [:]
            )
            allGameUnits.append(gameUnit)
        }

        for unit in viewModel.killedUnits {
            let gameUnit = Unit(
                name: unit.name,
                army: unit.army,
                hexagon: HexagonCoordinate(row: 0, col: 0),
                orientation: unit.orientation,
                exhausted: unit.exhausted,
                hitMarker: unit.hitMarker,
                stressed: unit.stressed,
                state: .killed,
                statsDictionary: [:]
            )
            allGameUnits.append(gameUnit)
        }

        for card in viewModel.germanCards {
            GermanCards[card.code, default: 0] += 1
        }

        for card in viewModel.sovietCards {
            SovietCards[card.code, default: 0] += 1
        }

        let updatedGameState = GameState(
            round: viewModel.gameState.round,
            victoryPoints: viewModel.gameState.victoryPoints,
            victoryMarker: viewModel.gameState.victoryMarker,
            caps: viewModel.gameState.caps,
            germanCards: GermanCards,
            sovietCards: SovietCards
        )

        let updatedMissionData = MissionData(
            gameSetup: missionData.gameSetup,
            gameState: updatedGameState,
            gameUnits: allGameUnits
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(updatedMissionData)
            try jsonData.write(to: fileURL)
            print("Mission saved successfully to \(fileURL.path)")
        } catch {
            print("Error saving mission: \(error.localizedDescription)")
        }
    }

    private func drawCards(for playerCards: inout [Card], number: Int) {
        for _ in 0..<number {
            if let card = cardDeck.drawRandomCard(ofType: .battle, upToCode: viewModel.missionData?.gameSetup.card.maxCode ?? "17") {
                playerCards.append(card)
            } else {
                print("No more battle cards are available!")
                break
            }
        }
    }

    func startNewRound() {
        viewModel.startNewRound()

        guard let missionData = viewModel.missionData else {
            print("Mission data is not available!")
            return
        }

        drawCards(for: &viewModel.germanCards, number: missionData.gameSetup.card.german.eachRound)
        drawCards(for: &viewModel.sovietCards, number: missionData.gameSetup.card.soviet.eachRound)
    }

    private func resetHitMarkers(in cells: [HexagonCell]) {
        cells.forEach { cell in
            cell.units.forEach { unit in
                if let hitMarker = unit.hitMarker {
                    hitMarkerPool.returnHitMarker(hitMarker)
                    unit.hitMarker = nil
                }
            }
        }
    }

    private func resetCards(_ cards: inout [Card]) {
        cards.forEach { cardDeck.returnCard($0) }
        cards.removeAll()
    }

    func resetGame() {
        resetHitMarkers(in: viewModel.inGameUnits)
        resetCards(&viewModel.germanCards)
        resetCards(&viewModel.sovietCards)
    }

    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
        print("Matchmaker cancelled.")
        viewController.dismiss(nil)
    }

    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker failed: \(error.localizedDescription)")
        viewController.dismiss(nil)
    }

    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFind match: GKTurnBasedMatch) {
        print("Match found: \(match.matchID)")
        viewController.dismiss(nil)

        self.match = match

        if let matchData = match.matchData, !matchData.isEmpty {
            print("Existing match data found, loading game...")
            handleMatch(match)
        } else {
            print("New match, setting up game...")
            setupNewMatch(match)
        }
    }

    func setupNewMatch(_ match: GKTurnBasedMatch) {
        guard match.participants.count == 2 else {
            print("Error: Need exactly 2 players to start the game")
            return
        }

        do {
            let encoder = JSONEncoder()
            let gameStateData = try encoder.encode(viewModel)

            match.saveCurrentTurn(withMatch: gameStateData) { error in
                if let error = error {
                    print("Error saving new match state: \(error.localizedDescription)")
                } else {
                    print("New match state saved!")
                }
            }
        } catch {
            print("Error encoding new match state: \(error.localizedDescription)")
        }
    }

    func startMatch() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2

        let matchmaker = GKTurnBasedMatchmakerViewController(matchRequest: request)
        matchmaker.turnBasedMatchmakerDelegate = self

        if let keyWindow = NSApplication.shared.keyWindow,
           let rootViewController = keyWindow.contentViewController {
            rootViewController.presentAsSheet(matchmaker)
        } else {
            print("Error: Could not find a valid window or root view controller to present the matchmaker.")
        }
    }

    func updateGameState(for match: GKTurnBasedMatch) {
        do {
            let encoder = JSONEncoder()
            let gameStateData = try encoder.encode(viewModel)

            guard let currentParticipant = match.currentParticipant else {
                print("Error: No current participant in match.")
                return
            }

            let nextParticipants = match.participants.filter { $0 != currentParticipant && $0.matchOutcome == .none }

            match.endTurn(
                withNextParticipants: nextParticipants,
                turnTimeout: GKTurnTimeoutDefault,
                match: gameStateData
            ) { error in
                if let error = error {
                    print("Failed to update game state: \(error.localizedDescription)")
                } else {
                    print("Game state updated successfully!")
                }
            }
        } catch {
            print("Error encoding game state: \(error.localizedDescription)")
        }
    }

    func handleMatch(_ match: GKTurnBasedMatch) {
        match.loadMatchData { data, error in
            guard let data = data else {
                print("Error loading match data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoder = JSONDecoder()
                let updatedGameState = try decoder.decode(GameViewModel.self, from: data)

                DispatchQueue.main.async {
                    self.viewModel = updatedGameState
                    self.match = match
                    print("Game state updated from received match data!")
                }
            } catch {
                print("Error decoding game state: \(error.localizedDescription)")
            }
        }
    }

    func endTurn(for match: GKTurnBasedMatch) {
        guard let currentParticipant = match.currentParticipant else {
            print("Error: No current participant in match.")
            return
        }

        let nextParticipants = match.participants
            .filter { $0 != currentParticipant && $0.matchOutcome == .none }

        guard let nextParticipant = nextParticipants.first else {
            print("Error: No valid next participant.")
            return
        }

        do {
            let encoder = JSONEncoder()
            let gameStateData = try encoder.encode(viewModel)

            match.endTurn(
                withNextParticipants: [nextParticipant],
                turnTimeout: GKTurnTimeoutDefault,
                match: gameStateData
            ) { error in
                if let error = error {
                    print("Failed to update game state: \(error.localizedDescription)")
                } else {
                    print("Turn ended, game state sent to opponent!")
                }
            }
        } catch {
            print("Error encoding game state: \(error.localizedDescription)")
        }
    }
}

extension GameManager: GKLocalPlayerListener {
    func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
        print("Received turn event for match: \(match.matchID)")
        handleMatch(match)
    }

    func player(_ player: GKPlayer, matchEnded match: GKTurnBasedMatch) {
        print("Match ended: \(match.matchID)")
    }
}

func authenticatePlayer() {
    GKLocalPlayer.local.authenticateHandler = { viewController, error in
        if let viewController = viewController {
            if let keyWindow = NSApplication.shared.keyWindow {
                keyWindow.contentViewController?.presentAsSheet(viewController)
            }
        } else if GKLocalPlayer.local.isAuthenticated {
            print("Player authenticated as \(GKLocalPlayer.local.displayName)")
        } else {
            print("Player authentication failed: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}
