//
//  Card.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 12.12.24.
//

import SwiftUI

class Card: Codable, Equatable {
    var id: String
    var name: String
    var type: CardType
    var item: Int
    var description: String
    var text: String
    var cost: Int? = nil
    var isCAP: Bool? = false
    var iconType: CardIconType
    var battleIcon: [CardBattleIcon]

    init(id: String, name: String, type: CardType, item: Int, description: String, text: String, cost: Int? = nil, isCAP: Bool? = nil, iconType: CardIconType, battleIcon: [CardBattleIcon]) {
        self.id = id
        self.name = name
        self.type = type
        self.item = item
        self.description = description
        self.text = text
        self.cost = cost
        self.isCAP = isCAP
        self.iconType = iconType
        self.battleIcon = battleIcon
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}

enum CardType: String, Codable {
    case battle
    case mission
    case artillery
    var id: Self { self }
    var name: String { rawValue.capitalized }
}

enum CardIconType: String, Codable {
    case action
    case bonus
    case mission
    case artillery
    var id: Self { self }
    var name: String { rawValue.capitalized }
}

enum CardBattleIcon: String, Codable {
    case hidden
    case groups
    case explosive
    var id: Self { self }
    var name: String { rawValue.capitalized }
}