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
    var exhausted: Bool
    var hitMarker: HitMarker?
    var stressed: Bool
    var stats: UnitStats

    var identifier: UnitIdentifier {
        return UnitIdentifier(name: name, army: army)
    }

    init(id: UUID = UUID(), name: String, game: UnitGame? = nil, army: UnitArmy, hexagon: HexagonCoordinate = HexagonCoordinate(row: 0, col: 0), orientation: UnitFront = .N, exhausted: Bool = false, hitMarker: HitMarker? = nil, stressed: Bool = false, statsDictionary: [UnitIdentifier: UnitStats]) {
        self.id = id
        self.name = name
        self.game = game
        self.army = army
        self.hexagon = hexagon
        self.orientation = orientation
        self.exhausted = exhausted
        self.hitMarker = hitMarker
        self.stressed = stressed

        let identifier = UnitIdentifier(name: name, army: army)
        self.stats = statsDictionary[identifier] ?? UnitStats(name: name, army: army)
        self.game = stats.game
    }

    static var unitType = UTType(exportedAs: "com.example.unit")

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Unit.self, contentType: unitType)
    }

    static func == (lhs: Unit, rhs: Unit) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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

struct UnitIdentifier: Hashable {
    let name: String
    let army: UnitArmy
}
