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
    @Published var leading: UnitArmy = .german
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
        roundLimit = mission.gameSetup.rounds
        victoryPoints = mission.gameState.victoryPoints
        leading = mission.gameState.victoryMarker
        germanCardPerRound = mission.gameState.germanBattleCards.eachRound
        sovietCardPerRound = mission.gameState.sovietBattleCards.eachRound
        germanCAPs = mission.gameState.germanCommandPoints.eachRound
        sovietCAPs = mission.gameState.sovietCommandPoints.eachRound
        germanMaxCAPs = mission.gameState.germanCommandPoints.eachRound
        sovietMaxCAPs = mission.gameState.sovietCommandPoints.eachRound
    }

    func startNewRound() {
        guard round < roundLimit else {
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
