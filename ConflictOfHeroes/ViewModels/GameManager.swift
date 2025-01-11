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

    func startNewMission(missionName: String) {
        viewModel.loadNewMission(missionName, cardDeck: cardDeck)

        guard let missionData = viewModel.missionData else {
            print("Mission data is not available!")
            return
        }

        drawCards(for: &viewModel.germanCards, number: missionData.gameSetup.card.german.startWith)
        drawCards(for: &viewModel.sovietCards, number: missionData.gameSetup.card.soviet.startWith)
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

    func resetGame() {
        resetHitMarkers(in: viewModel.inGameUnits)
        resetCards(&viewModel.germanCards)
        resetCards(&viewModel.sovietCards)
    }

    func loadMission(missionData: MissionData) {
        let mission = Mission(rawValue: missionData.gameSetup.name) ?? .mission1
        let (inGame, backUp, killed) = loadInitialUnits(for: mission, missionData: missionData)

        viewModel.missionData = missionData
        viewModel.gameState = missionData.gameState
        viewModel.inGameUnits = inGame
        viewModel.backUpUnits = backUp
        viewModel.killedUnits = killed
    }

    func loadInitialUnits(for mission: Mission, missionData: MissionData) -> ([HexagonCell], [Unit], [Unit]) {
        var inGameUnits: [HexagonCell] = []
        var backUpUnits: [Unit] = []
        var killedUnits: [Unit] = []

        let columns = missionData.gameSetup.cols
        let evenColumnRows = missionData.gameSetup.rows
        let oddColumnRows = evenColumnRows - 1

        for column in 0..<columns {
            let rows = column.isMultiple(of: 2) ? evenColumnRows : oddColumnRows
            for row in 0..<rows {
                let coordinate = HexagonCoordinate(row: row, col: column)

                var updatedCell = HexagonCell(offsetCoordinate: coordinate, units: [])

                let unitsOnHex = missionData.gameUnits.filter {
                    $0.hexagon == coordinate && $0.state == .inGame
                }

                for gameUnit in unitsOnHex {
                    let unit = Unit(
                        name: gameUnit.name,
                        army: gameUnit.army,
                        hexagon: gameUnit.hexagon,
                        orientation: gameUnit.orientation,
                        exhausted: gameUnit.exhausted,
                        hitMarker: gameUnit.hitMarker,
                        stressed: gameUnit.stressed,
                        state: gameUnit.state,
                        statsDictionary: [:]
                    )
                    updatedCell.units.append(unit)
                }

                inGameUnits.append(updatedCell)
            }
        }

        backUpUnits = missionData.gameUnits.filter { $0.state == .backUp }.map {
            Unit(
                name: $0.name,
                army: $0.army,
                hexagon: $0.hexagon,
                orientation: $0.orientation,
                exhausted: $0.exhausted,
                hitMarker: $0.hitMarker,
                stressed: $0.stressed,
                state: $0.state,
                statsDictionary: [:]
            )
        }

        killedUnits = missionData.gameUnits.filter { $0.state == .killed }.map {
            Unit(
                name: $0.name,
                army: $0.army,
                hexagon: $0.hexagon,
                orientation: $0.orientation,
                exhausted: $0.exhausted,
                hitMarker: $0.hitMarker,
                stressed: $0.stressed,
                state: $0.state,
                statsDictionary: [:]
            )
        }

        return (inGameUnits, backUpUnits, killedUnits)
    }

    func saveMission(to fileURL: URL) {
        guard let missionData = viewModel.missionData else {
            print("Error: No mission data to save.")
            return
        }

        var allGameUnits: [Unit] = []

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

        let updatedMissionData = MissionData(
            gameSetup: missionData.gameSetup,
            gameState: viewModel.gameState,
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
}
