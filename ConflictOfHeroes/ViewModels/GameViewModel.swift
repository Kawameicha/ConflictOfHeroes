//
//  GameViewModel.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 20.12.24.
//


import Foundation

class GameViewModel: ObservableObject {
    @Published var inGameUnits: [HexagonCell] = []
    @Published var backUpUnits: [Unit] = []
    @Published var killedUnits: [Unit] = []
    @Published var missionData: MissionData?
    @Published var selectedHex: HexagonCell?
    @Published var round: Int = 1
    @Published var victoryPoints: Int = 1
    @Published var victoryMarker: UnitArmy = .german
    @Published var germanCAPs: Int = 0
    @Published var sovietCAPs: Int = 0
    @Published var germanMaxCAPs: Int = 0
    @Published var sovietMaxCAPs: Int = 0
    @Published var germanCards: [Card] = []
    @Published var sovietCards: [Card] = []
    @Published var isShowingBackUpUnits: Bool = false
    @Published var isShowingKilledUnits: Bool = false
    @Published var isShowingGermanCards: Bool = false
    @Published var isShowingSovietCards: Bool = false

    func loadMission(_ missionName: String, cardDeck: CardDeck) {
        guard let mission = loadMissionData(from: missionName) else {
            print("Error: Could not load mission \(missionName)")
            return
        }
        missionData = mission

        let (inGame, backUp, killed) = setupInitialUnits(for: Mission(rawValue: missionName) ?? .mission1)
        inGameUnits = inGame
        backUpUnits = backUp
        killedUnits = killed

        round = 1
        victoryPoints = mission.gameState.victoryPoints
        victoryMarker = mission.gameState.victoryMarker
        germanCAPs = mission.gameSetup.caps.german
        sovietCAPs = mission.gameSetup.caps.soviet
        germanMaxCAPs = mission.gameSetup.caps.german
        sovietMaxCAPs = mission.gameSetup.caps.soviet

        germanCards = mission.gameState.germanCards.flatMap { code, count in
            cardDeck.drawNonRandomCards(code: code, count: count)
        }
        sovietCards = mission.gameState.sovietCards.flatMap { code, count in
            cardDeck.drawNonRandomCards(code: code, count: count)
        }
        
    }

    func startNewRound() {
        guard round < missionData?.gameSetup.last ?? 5 else {
            print("No more rounds left.")
            return
        }

        round += 1
        germanCAPs = germanMaxCAPs
        sovietCAPs = sovietMaxCAPs
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
