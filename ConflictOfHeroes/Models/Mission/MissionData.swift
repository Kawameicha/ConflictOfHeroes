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
    var gameUnits: [Unit]

    init(gameSetup: GameSetup, gameState: GameState, gameUnits: [Unit]) {
        self.gameSetup = gameSetup
        self.gameState = gameState
        self.gameUnits = gameUnits
    }
}

struct GameSetup: Codable {
    let name: String
    let date: String
    let text: String
    let card: CardSetup
    let caps: CapsSetup
    let last: Int
    let maps: [MapsSetup]
    let cols: Int
    let rows: Int

    init(
        name: String,
        date: String,
        text: String,
        card: CardSetup,
        caps: CapsSetup,
        rounds: Int,
        maps: [MapsSetup],
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

    struct CardSetup: Codable {
        struct PlayerCard: Codable {
            var startWith: Int
            var eachRound: Int

            init(startWith: Int, eachRound: Int) {
                self.startWith = startWith
                self.eachRound = eachRound
            }
        }

        let german: PlayerCard
        let soviet: PlayerCard
        let maxCode: String

        init(german: PlayerCard, soviet: PlayerCard, maxCode: String) {
            self.german = german
            self.soviet = soviet
            self.maxCode = maxCode
        }
    }

    struct CapsSetup: Codable {
        var german: Int
        var soviet: Int

        init(german: Int, soviet: Int) {
            self.german = german
            self.soviet = soviet
        }
    }

    struct MapsSetup: Codable {
        let name: String
        let orientation: MapFacing

        enum MapFacing: String, Codable {
            case N, E, S, W

            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let rawValue = try container.decode(String.self).uppercased()
                guard let value = MapFacing(rawValue: rawValue) else {
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
    }
}

class GameState: ObservableObject, Codable {
    @Published var round: Int
    @Published var victoryPoints: Int
    @Published var victoryMarker: UnitArmy
    @Published var caps: GameSetup.CapsSetup
    @Published var germanCards: [String: Int]
    @Published var sovietCards: [String: Int]

    init(round: Int, victoryPoints: Int, victoryMarker: UnitArmy, caps: GameSetup.CapsSetup, germanCards: [String: Int], sovietCards: [String: Int]) {
        self.round = round
        self.victoryPoints = victoryPoints
        self.victoryMarker = victoryMarker
        self.caps = caps
        self.germanCards = germanCards
        self.sovietCards = sovietCards
    }

    static let `default` = GameState(
        round: 1,
        victoryPoints: 1,
        victoryMarker: .german,
        caps: GameSetup.CapsSetup(german: 7, soviet: 7),
        germanCards: [:],
        sovietCards: [:]
    )

    enum CodingKeys: String, CodingKey {
        case round
        case victoryPoints
        case victoryMarker
        case caps
        case germanCards
        case sovietCards
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        round = try container.decode(Int.self, forKey: .round)
        victoryPoints = try container.decode(Int.self, forKey: .victoryPoints)
        victoryMarker = try container.decode(UnitArmy.self, forKey: .victoryMarker)
        caps = try container.decode(GameSetup.CapsSetup.self, forKey: .caps)
        germanCards = try container.decode([String: Int].self, forKey: .germanCards)
        sovietCards = try container.decode([String: Int].self, forKey: .sovietCards)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(round, forKey: .round)
        try container.encode(victoryPoints, forKey: .victoryPoints)
        try container.encode(victoryMarker, forKey: .victoryMarker)
        try container.encode(caps, forKey: .caps)
        try container.encode(germanCards, forKey: .germanCards)
        try container.encode(sovietCards, forKey: .sovietCards)
    }
}

enum Mission: String {
    case mission1
    case mission2
    case mission3
    case mission4
}
