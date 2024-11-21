//
//  MissionData.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 21.11.24.
//

import Foundation

struct MissionData: Codable {
    struct Metadata: Codable {
        let germanVictoryPoints: Int
        let sovietVictoryPoints: Int
        let germanCommandPoints: Int
        let sovietCommandPoints: Int
        let rounds: Int
    }

    struct MissionUnit: Codable {
        let name: String
        let type: UnitType
        let army: UnitArmy
        let hexagon: HexagonCoordinate
        let orientation: UnitFront
    }

    let metadata: Metadata
    let units: [MissionUnit]
}

enum Mission: String {
    case mission1
    case mission2
}
