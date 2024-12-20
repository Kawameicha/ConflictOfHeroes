//
//  GameViewModel.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 20.12.24.
//


import Foundation

class GameViewModel: ObservableObject {
    @Published var initialCells: [HexagonCell] = []
    @Published var selectedHexagon: HexagonCell?
    @Published var reserveUnits: [Unit] = []
    @Published var removedUnits: [Unit] = []
    @Published var missionData: MissionData?
    @Published var round: Int = 1
    @Published var roundLimit: Int = 5
    @Published var victoryPoints: Int = 1
    @Published var germanCAP: Int = 0
    @Published var sovietCAP: Int = 0
    @Published var leading: UnitArmy = .german
    @Published var isShowingReserveUnits: Bool = false
    private weak var gameManager: GameManager?

    func loadMission(_ missionName: String) {
        guard let mission = loadMissionData(from: missionName) else {
            print("Error: Could not load mission \(missionName)")
            return
        }
        missionData = mission

        let (cells, reserve) = setupInitialUnits(for: Mission(rawValue: missionName) ?? .mission1)
        initialCells = cells
        reserveUnits = reserve
        removedUnits = []

        round = 1
        roundLimit = mission.gameSetup.rounds
        victoryPoints = mission.gameState.victoryPoints
        germanCAP = mission.gameState.germanCommandPoints
        sovietCAP = mission.gameState.sovietCommandPoints
        leading = mission.gameState.victoryMarker
    }

    func startNewRound() {
        guard round < roundLimit else {
            print("No more rounds left.")
            return
        }

        round += 1
        initialCells.forEach { cell in
            cell.units.forEach { unit in
                unit.exhausted = false
                unit.stressed = false
            }
        }
    }

    func resetGameState() {
//        selectedHexagon = nil
//        reserveUnits.removeAll()
//        removedUnits.removeAll()
//        initialCells.removeAll()
//        missionData = nil
//        round = 1
//        roundLimit = 5
//        victoryPoints = 0
//        germanCAP = 0
//        sovietCAP = 0
//        leading = .german
//        isShowingReserveUnits = false
    }
}
