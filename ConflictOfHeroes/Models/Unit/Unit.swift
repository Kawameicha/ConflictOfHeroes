//
//  Unit.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI
import UniformTypeIdentifiers

@Observable
class Unit: Identifiable, Hashable, Transferable, Codable {
    var id = UUID()
    var name: String
    var game: UnitGame? = .AtB
    var army: UnitArmy
    var hexagon: HexagonCoordinate
    var orientation: UnitFront
    var exhausted: Bool = false
    var hitMarker: HitMarker?
    var stressed: Bool = false
    var state: UnitState = .inGame

    var identifier: UnitIdentifier {
        return UnitIdentifier(name: name, army: army)
    }

    var stats: UnitStats {
        let identifier = UnitIdentifier(name: name, army: army)
        return Unit.statsDictionary[identifier] ?? UnitStats(name: name, army: army)
    }

    static var statsDictionary: [UnitIdentifier: UnitStats] = [:]

    init(
        id: UUID = UUID(),
        name: String,
        game: UnitGame? = .AtB,
        army: UnitArmy,
        hexagon: HexagonCoordinate = HexagonCoordinate(row: 0, col: 0),
        orientation: UnitFront = .N,
        exhausted: Bool = false,
        hitMarker: HitMarker? = nil,
        stressed: Bool = false,
        state: UnitState = .inGame,
        statsDictionary: [UnitIdentifier: UnitStats]
    ) {
        self.id = id
        self.name = name
        self.game = game
        self.army = army
        self.hexagon = hexagon
        self.orientation = orientation
        self.exhausted = exhausted
        self.hitMarker = hitMarker
        self.stressed = stressed
        self.state = state
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        game = try container.decodeIfPresent(UnitGame.self, forKey: .game)
        army = try container.decode(UnitArmy.self, forKey: .army)
        hexagon = try container.decode(HexagonCoordinate.self, forKey: .hexagon)
        orientation = try container.decode(UnitFront.self, forKey: .orientation)
        exhausted = try container.decodeIfPresent(Bool.self, forKey: .exhausted) ?? false
        hitMarker = try container.decodeIfPresent(HitMarker.self, forKey: .hitMarker)
        stressed = try container.decodeIfPresent(Bool.self, forKey: .stressed) ?? false
        state = try container.decodeIfPresent(UnitState.self, forKey: .state) ?? .inGame
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(game, forKey: .game)
        try container.encode(army, forKey: .army)
        try container.encode(hexagon, forKey: .hexagon)
        try container.encode(orientation, forKey: .orientation)
        try container.encode(exhausted, forKey: .exhausted)
        try container.encodeIfPresent(hitMarker, forKey: .hitMarker)
        try container.encode(stressed, forKey: .stressed)
        try container.encode(state, forKey: .state)
    }

    enum CodingKeys: String, CodingKey {
        case id, name, game, army, hexagon, orientation, exhausted, hitMarker, stressed, state
    }

    static var unitType = UTType(exportedAs: "com.game.unit")

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Unit.self, contentType: unitType)
    }

    static func == (lhs: Unit, rhs: Unit) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    enum UnitState: String, Codable {
        case inGame
        case backUp
        case killed
    }
}

enum UnitGame: String, Codable {
    case AtB = "Awakening the Bear"
    case SoS = "Storm of Steel"
    var id: Self { self }
    var name: String { rawValue.capitalized }
}

enum UnitType: String, Codable {
    case foot
    case tracked
    case wheeled
    var id: Self { self }
    var name: String { rawValue.capitalized }
}

enum UnitArmy: String, Codable {
    case german = "german"
    case soviet = "soviet"
    var id: Self { self }
    var name: String { rawValue.capitalized }
}

enum UnitFront: String, Codable {
    case N = "North"
    case NE = "North-East"
    case SE = "South-East"
    case S = "South"
    case SW = "South-West"
    case NW = "North-West"
    var id: Self { self }
    var name: String { rawValue.capitalized }
}

struct UnitIdentifier: Hashable, Codable {
    let name: String
    let army: UnitArmy
}
