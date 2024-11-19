//
//  UnitStats.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 17.11.24.
//

import Foundation

struct UnitStats: Codable {
    var name: String = ""
    var desc: String = ""
    var game: UnitGame? = .AtB
    var type: UnitType = .foot
    var army: UnitArmy = .german
    var costAttack: Int? = nil
    var indirectAttack: Int? = nil
    var turretUnit: Bool? = false
    var costMove: Int? = nil
    var moveBon1: UnitType? = nil
    var moveBon2: UnitType? = nil
    var defBonus: Int? = nil
    var attackSoft: Int? = nil
    var attackArmored: Int? = nil
    var attackSort: UnitAttack? = nil
    var crewedUnit: Bool? = false
    var minRange: Int? = nil
    var maxRange: Int? = nil
    var defenseFlank: Int? = nil
    var defenseFront: Int? = nil
    var openVehicle: Bool? = false

    var identifier: UnitIdentifier {
        return UnitIdentifier(name: name, army: army)
    }

    init(name: String = "", desc: String = "", game: UnitGame? = .AtB, type: UnitType = .foot, army: UnitArmy = .german, costAttack: Int? = nil, indirectAttack: Int? = nil, turretUnit: Bool? = false, costMove: Int? = nil, moveBon1: UnitType? = nil, moveBon2: UnitType? = nil, defBonus: Int? = nil, attackSoft: Int? = nil, attackArmored: Int? = nil, attackSort: UnitAttack? = nil, crewedUnit: Bool? = false, minRange: Int? = nil, maxRange: Int? = nil, defenseFlank: Int? = nil, defenseFront: Int? = nil, openVehicle: Bool? = false) {
        self.name = name
        self.desc = desc
        self.game = game
        self.type = type
        self.army = army
        self.costAttack = costAttack
        self.indirectAttack = indirectAttack
        self.turretUnit = turretUnit
        self.costMove = costMove
        self.moveBon1 = moveBon1
        self.moveBon2 = moveBon2
        self.defBonus = defBonus
        self.attackSoft = attackSoft
        self.attackArmored = attackArmored
        self.attackSort = attackSort
        self.crewedUnit = crewedUnit
        self.minRange = minRange
        self.maxRange = maxRange
        self.defenseFlank = defenseFlank
        self.defenseFront = defenseFront
        self.openVehicle = openVehicle
    }
}

enum UnitAttack: String, Codable {
    case flamethrower, explosive
    var id: Self { self }
    var name: String { rawValue.capitalized }
}
