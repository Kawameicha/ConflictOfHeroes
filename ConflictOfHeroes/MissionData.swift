//
//  MissionData.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 21.11.24.
//

import Foundation

struct MissionData: Codable {
    let gameSetup: GameSetup
    var gameState: GameState
    var gameUnits: [GameUnit]
}

struct GameSetup: Codable {
    let name: String
    let date: String
    let maps: String
    let rounds: Int
    let columns: Int
    let evenColumnRows: Int
    let oddColumnRows: Int

    init(name: String, date: String, maps: String, rounds: Int, columns: Int, evenColumnRows: Int, oddColumnRows: Int) {
        self.name = name
        self.date = date
        self.maps = maps
        self.rounds = rounds
        self.columns = columns
        self.evenColumnRows = evenColumnRows
        self.oddColumnRows = oddColumnRows
    }
}

struct GameState: Codable {
    var victoryPoints: Int
    var victoryMarker: UnitArmy
    var germanCommandPoints: Int
    var sovietCommandPoints: Int
}

struct GameUnit: Codable {
    var name: String
    var army: UnitArmy
    var hexagon: HexagonCoordinate
    var orientation: UnitFront
    var isReserve: Bool
}

enum Mission: String {
    case mission0
    case mission1
    case mission2
}
