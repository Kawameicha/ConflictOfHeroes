//
//  GameViewModel.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 20.12.24.
//

import Foundation

class GameViewModel: ObservableObject, Codable {
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

    enum CodingKeys: String, CodingKey {
        case missionData, gameState, selectedHex, inGameUnits, backUpUnits, killedUnits, germanCards, sovietCards
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        missionData = try container.decodeIfPresent(MissionData.self, forKey: .missionData)
        gameState = try container.decode(GameState.self, forKey: .gameState)
        inGameUnits = try container.decode([HexagonCell].self, forKey: .inGameUnits)
        backUpUnits = try container.decode([Unit].self, forKey: .backUpUnits)
        killedUnits = try container.decode([Unit].self, forKey: .killedUnits)
        germanCards = try container.decode([Card].self, forKey: .germanCards)
        sovietCards = try container.decode([Card].self, forKey: .sovietCards)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(missionData, forKey: .missionData)
        try container.encode(gameState, forKey: .gameState)
        try container.encode(inGameUnits, forKey: .inGameUnits)
        try container.encode(backUpUnits, forKey: .backUpUnits)
        try container.encode(killedUnits, forKey: .killedUnits)
        try container.encode(germanCards, forKey: .germanCards)
        try container.encode(sovietCards, forKey: .sovietCards)
    }

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
