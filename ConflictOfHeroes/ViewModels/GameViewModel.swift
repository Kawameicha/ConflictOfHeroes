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
    @Published var killedUnits: [Unit] = [] {
            didSet {
                adjustCapsForKilledUnits()
            }
        }
    @Published var germanCards: [Card] = []
    @Published var sovietCards: [Card] = []
    @Published var isShowingBackUpUnits: Bool = false
    @Published var isShowingKilledUnits: Bool = false
    @Published var isShowingGermanCards: Bool = false
    @Published var isShowingSovietCards: Bool = false

    init(missionData: MissionData? = nil) {
        self.missionData = missionData
    }

    private func adjustCapsForKilledUnits() {
        guard let missionData = missionData else { return }

        let killedGermanUnits = killedUnits.filter { $0.army == .german
            && !["Wagon", "Opel Blitz"].contains($0.name) }.count
        let killedSovietUnits = killedUnits.filter { $0.army == .soviet
            && !["Wagon", "Truck"].contains($0.name) }.count

        let maxCapsGerman = max(missionData.gameSetup.caps.german - killedGermanUnits, 3)
        if maxCapsGerman <= gameState.caps.german {
            gameState.caps.german = maxCapsGerman
        }

        let maxCapsSoviet = max(missionData.gameSetup.caps.soviet - killedSovietUnits, 3)
        if maxCapsSoviet <= gameState.caps.soviet {
            gameState.caps.soviet = maxCapsSoviet
        }
    }

    func startNewRound() {
        if let missionData = missionData {
            guard gameState.round < missionData.gameSetup.last else {
                print("No more rounds left.")
                return
            }

            gameState.round += 1

            let killedGermanUnits = killedUnits.filter { $0.army == .german
                && !["Wagon", "Opel Blitz"].contains($0.name) }.count
            gameState.caps.german = max(missionData.gameSetup.caps.german - killedGermanUnits, 3)

            let killedSovietUnits = killedUnits.filter { $0.army == .soviet
                && !["Wagon", "Truck"].contains($0.name) }.count
            gameState.caps.soviet = max(missionData.gameSetup.caps.soviet - killedSovietUnits, 3)

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

    func toggleVictoryMarker() {
            gameState.victoryMarker = (gameState.victoryMarker == .german) ? .soviet : .german
            objectWillChange.send()
        }
}
