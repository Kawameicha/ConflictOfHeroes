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
    let text: String
    let card: CardSetup
    let caps: CapsSetup
    let last: Int
    let maps: [MapInfo]
    let cols: Int
    let rows: Int

    init(
        name: String,
        date: String,
        text: String,
        card: CardSetup,
        caps: CapsSetup,
        rounds: Int,
        maps: [MapInfo],
        columns: Int,
        rows: Int
    ) {
        self.name = name
        self.date = date
        self.text = text
        self.card = card
        self.caps = caps
        self.last = rounds
        self.maps = maps
        self.cols = columns
        self.rows = rows
    }
}

class CardSetup: Codable {
    let german: PlayerCard
    let soviet: PlayerCard
    let maxCode: String

    init(german: PlayerCard, soviet: PlayerCard, maxCode: String) {
        self.german = german
        self.soviet = soviet
        self.maxCode = maxCode
    }
}

class PlayerCard: Codable {
    var startWith: Int
    var eachRound: Int

    init(startWith: Int, eachRound: Int) {
        self.startWith = startWith
        self.eachRound = eachRound
    }
}

class CapsSetup: Codable {
    let german: Int
    let soviet: Int

    init(german: Int, soviet: Int) {
        self.german = german
        self.soviet = soviet
    }
}

struct MapInfo: Codable {
    let name: String
    let orientation: MapsSetup
}

enum MapsSetup: String, Codable {
    case N
    case E
    case S
    case W

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self).uppercased()
        guard let value = MapsSetup(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot initialize MapsSetup from invalid String value \(rawValue)"
            )
        }
        self = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

class GameState: Codable {
    var victoryPoints: Int
    var victoryMarker: UnitArmy
    var germanCards: [String:Int]
    var sovietCards: [String:Int]

    init(victoryPoints: Int, victoryMarker: UnitArmy, germanCards: [String : Int], sovietCards: [String : Int]) {
        self.victoryPoints = victoryPoints
        self.victoryMarker = victoryMarker
        self.germanCards = germanCards
        self.sovietCards = sovietCards
    }
}

class GameUnit: Codable {
    var name: String
    var army: UnitArmy
    var hexagon: HexagonCoordinate
    var orientation: UnitFront
    var state: UnitState

    init(name: String, army: UnitArmy, hexagon: HexagonCoordinate, orientation: UnitFront, state: UnitState) {
        self.name = name
        self.army = army
        self.hexagon = hexagon
        self.orientation = orientation
        self.state = state
    }
}

enum UnitState: String, Codable {
    case inGame
    case backUp
    case killed
}

enum Mission: String {
    case mission1
    case mission2
    case mission3
    case mission4
}
