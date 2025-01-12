//
//  GameManager.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 04.12.24.
//

import Foundation

class GameManager: ObservableObject {
    @Published var viewModel: GameViewModel
    @Published var cardDeck: CardDeck
    @Published var hitMarkerPool: HitMarkerPool

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
        let (inGame, backUp, killed) = loadInitialUnits(for: mission, missionData: missionData)

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
}
