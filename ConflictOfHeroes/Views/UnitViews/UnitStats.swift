//
//  UnitStats.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 17.11.24.
//

import Foundation

struct UnitStats: Codable {
    var id: String = ""
    var name: String = ""
    var desc: String = ""
    var game: UnitGame? = .AtB
    var type: UnitType = .foot
    var army: UnitArmy = .german
    var costAttack: Int? = nil
    var indirectAttack: Int? = nil
    var turretUnit: Bool? = false
    var costToMove: Int? = nil
    var moveBonus1: UnitType? = nil
    var moveBonus2: UnitType? = nil
    var coverBonus: Int? = nil
    var attackSoft: Int? = nil
    var attackHard: Int? = nil
    var attackSort: UnitAttack? = nil
    var crewedUnit: Bool? = false
    var crewedType: UnitType? = nil
    var minRange: Int? = nil
    var maxRange: Int? = nil
    var defenseFlank: Int? = nil
    var flankType: UnitType = .foot
    var defenseFront: Int? = nil
    var frontType: UnitType = .foot
    var openVehicle: Bool? = false

    var identifier: UnitIdentifier {
        return UnitIdentifier(name: name, army: army)
    }

    init(id: String = "", name: String = "", desc: String = "", game: UnitGame? = .AtB, type: UnitType = .foot, army: UnitArmy = .german, costAttack: Int? = nil, indirectAttack: Int? = nil, turretUnit: Bool? = false, costMove: Int? = nil, moveBon1: UnitType? = nil, moveBon2: UnitType? = nil, defBonus: Int? = nil, attackSoft: Int? = nil, attackArmored: Int? = nil, attackSort: UnitAttack? = nil, crewedUnit: Bool? = false, crewedType: UnitType? = nil, minRange: Int? = nil, maxRange: Int? = nil, defenseFlank: Int? = nil, flankType: UnitType = .foot, defenseFront: Int? = nil, frontType: UnitType = .foot, openVehicle: Bool? = false) {
        self.id = id
        self.name = name
        self.desc = desc
        self.game = game
        self.type = type
        self.army = army
        self.costAttack = costAttack
        self.indirectAttack = indirectAttack
        self.turretUnit = turretUnit
        self.costToMove = costMove
        self.moveBonus1 = moveBon1
        self.moveBonus2 = moveBon2
        self.coverBonus = defBonus
        self.attackSoft = attackSoft
        self.attackHard = attackArmored
        self.attackSort = attackSort
        self.crewedUnit = crewedUnit
        self.crewedType = crewedType
        self.minRange = minRange
        self.maxRange = maxRange
        self.defenseFlank = defenseFlank
        self.flankType = flankType
        self.defenseFront = defenseFront
        self.frontType = frontType
        self.openVehicle = openVehicle
    }
}

enum UnitAttack: String, Codable {
    case flamethrower, explosive
    var id: Self { self }
    var name: String { rawValue.capitalized }
}
