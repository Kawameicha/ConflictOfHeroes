//
//  GameViewModel.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 20.12.24.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var missionData: MissionData?
    @Published var gameState: GameState = GameState.default
    @Published var selectedHex: HexagonCell?
    @Published var inGameUnits: [HexagonCell] = []
    @Published var backUpUnits: [Unit] = []
    @Published var killedUnits: [Unit] = []
    @Published var germanCards: [Card] = []
    @Published var sovietCards: [Card] = []
    @Published var isShowingBackUpUnits: Bool = false
    @Published var isShowingKilledUnits: Bool = false
    @Published var isShowingGermanCards: Bool = false
    @Published var isShowingSovietCards: Bool = false

    init(missionData: MissionData? = nil) {
        self.missionData = missionData
    }

    func loadNewMission(_ missionName: String, cardDeck: CardDeck) {
        guard let mission = loadMissionData(from: missionName) else {
            print("Error: Could not load mission \(missionName)")
            return
        }

        missionData = mission
        gameState = GameState(
            round: mission.gameState.round,
            victoryPoints: mission.gameState.victoryPoints,
            victoryMarker: mission.gameState.victoryMarker,
            caps: mission.gameState.caps,
            germanCards: mission.gameState.germanCards,
            sovietCards: mission.gameState.sovietCards
        )

        let (inGame, backUp, killed) = setupInitialUnits(for: Mission(rawValue: missionName) ?? .mission1)
        inGameUnits = inGame
        backUpUnits = backUp
        killedUnits = killed

        germanCards = mission.gameState.germanCards.flatMap { code, count in
            cardDeck.drawNonRandomCards(code: code, count: count)
        }
        sovietCards = mission.gameState.sovietCards.flatMap { code, count in
            cardDeck.drawNonRandomCards(code: code, count: count)
        }
    }

    func startNewRound() {
        if let missionData = missionData {
            guard gameState.round < missionData.gameSetup.last else {
                print("No more rounds left.")
                return
            }

            gameState.round += 1
            gameState.caps.german = missionData.gameSetup.caps.german
            gameState.caps.soviet = missionData.gameSetup.caps.soviet
            inGameUnits.forEach { cell in
                cell.units.forEach { unit in
                    if unit.name == "Smoke" && !unit.exhausted {
                        guard let sourceIndex = inGameUnits.firstIndex(where: { $0.id == cell.id }) else { return }
                        inGameUnits[sourceIndex].units.removeAll { $0 == unit }
                        backUpUnits.append(unit)
                    }

                    unit.exhausted = false
                    unit.stressed = false
                }
            }
        }
    }
}
