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
    @Published var victoryPoints: Int = 1
    @Published var victoryMarker: UnitArmy = .german
    @Published var germanCardPerRound: Int = 0
    @Published var sovietCardPerRound: Int = 0
    @Published var germanCAPs: Int = 0
    @Published var sovietCAPs: Int = 0
    @Published var germanMaxCAPs: Int = 0
    @Published var sovietMaxCAPs: Int = 0
    @Published var germanCards: [Card] = []
    @Published var sovietCards: [Card] = []
    @Published var isShowingReserveUnits: Bool = false
    @Published var isShowingGermanCards: Bool = false
    @Published var isShowingSovietCards: Bool = false

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
        victoryPoints = mission.gameState.victoryPoints
        victoryMarker = mission.gameState.victoryMarker
        germanCardPerRound = mission.gameSetup.card.german.eachRound
        sovietCardPerRound = mission.gameSetup.card.soviet.eachRound
        germanCAPs = mission.gameSetup.caps.german
        sovietCAPs = mission.gameSetup.caps.soviet
        germanMaxCAPs = mission.gameSetup.caps.german
        sovietMaxCAPs = mission.gameSetup.caps.soviet
    }

    func startNewRound() {
        guard round < missionData?.gameSetup.last ?? 5 else {
            print("No more rounds left.")
            return
        }

        round += 1
        germanCAPs = germanMaxCAPs
        sovietCAPs = sovietMaxCAPs
        initialCells.forEach { cell in
            cell.units.forEach { unit in
                unit.exhausted = false
                unit.stressed = false
            }
        }
    }
}
