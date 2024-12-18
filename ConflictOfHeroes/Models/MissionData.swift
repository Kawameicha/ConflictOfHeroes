//
//  MissionData.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 21.11.24.
//

import Foundation

class MissionData: Codable {
    let gameSetup: GameSetup
    var gameState: GameState
    var gameUnits: [GameUnit]

    init(gameSetup: GameSetup, gameState: GameState, gameUnits: [GameUnit]) {
        self.gameSetup = gameSetup
        self.gameState = gameState
        self.gameUnits = gameUnits
    }
}

class GameSetup: Codable {
    let name: String
    let date: String
    let maps: [String]
    let rounds: Int
    let columns: Int
    let evenColumnRows: Int
    let oddColumnRows: Int

    init(name: String, date: String, maps: [String], rounds: Int, columns: Int, evenColumnRows: Int, oddColumnRows: Int) {
        self.name = name
        self.date = date
        self.maps = maps
        self.rounds = rounds
        self.columns = columns
        self.evenColumnRows = evenColumnRows
        self.oddColumnRows = oddColumnRows
    }
}

class GameState: Codable {
    var victoryPoints: Int
    var victoryMarker: UnitArmy
    var germanCommandPoints: Int
    var sovietCommandPoints: Int

    init(victoryPoints: Int, victoryMarker: UnitArmy, germanCommandPoints: Int, sovietCommandPoints: Int) {
        self.victoryPoints = victoryPoints
        self.victoryMarker = victoryMarker
        self.germanCommandPoints = germanCommandPoints
        self.sovietCommandPoints = sovietCommandPoints
    }
}

class GameUnit: Codable {
    var name: String
    var army: UnitArmy
    var hexagon: HexagonCoordinate
    var orientation: UnitFront
    var isReserve: Bool

    init(name: String, army: UnitArmy, hexagon: HexagonCoordinate, orientation: UnitFront, isReserve: Bool) {
        self.name = name
        self.army = army
        self.hexagon = hexagon
        self.orientation = orientation
        self.isReserve = isReserve
    }
}

enum Mission: String {
    case mission0
    case mission1
    case mission2
    case mission3
}
