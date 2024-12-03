//
//  HitMarker.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 02.12.24.
//

import SwiftUI

import SwiftUI
import UniformTypeIdentifiers

class HitMarker: Codable {
    var id: String
    var name: String
    var type: HitMarkerType
    var item: Int
    var rally: Int? = nil
    var attackCost: Int? = nil
    var attackSoft: Int? = nil
    var attackHard: Int? = nil
    var attackDisabled: Bool? = false
    var gunDamaged: HitMarkerType? = nil
    var moveCost: Int? = nil
    var moveDisabled: Bool? = false
    var defenseFlank: Int? = nil
    var defenseFront: Int? = nil
    var rangeDisabled: Bool? = false

    init(id: String, name: String, type: HitMarkerType, item: Int, rally: Int? = nil, attackCost: Int? = nil, attackSoft: Int? = nil, attackHard: Int? = nil, attackDisabled: Bool? = nil, gunDamaged: HitMarkerType? = nil, moveCost: Int? = nil, moveDisabled: Bool? = nil, defenseFlank: Int? = nil, defenseFront: Int? = nil, rangeDisabled: Bool? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.item = item
        self.rally = rally
        self.attackCost = attackCost
        self.attackSoft = attackSoft
        self.attackHard = attackHard
        self.attackDisabled = attackDisabled
        self.gunDamaged = gunDamaged
        self.moveCost = moveCost
        self.moveDisabled = moveDisabled
        self.defenseFlank = defenseFlank
        self.defenseFront = defenseFront
        self.rangeDisabled = rangeDisabled
    }
}

enum HitMarkerType: String, Codable {
    case soft
    case hard
    var id: Self { self }
    var name: String { rawValue.capitalized }
}
