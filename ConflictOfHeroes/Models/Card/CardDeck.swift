//
//  CardDeck.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 12.12.24.
//

import SwiftUI

class CardDeck: ObservableObject {
    @Published var deck: [Card] = []

    init(cards: [Card]) {
        self.deck = Self.createCardDeck(from: cards)
    }

    static func createCardDeck(from cards: [Card]) -> [Card] {
        var deck: [Card] = []
        for card in cards {
            for _ in 0..<card.item {
                let newCard = Card(
                    code: card.code,
                    name: card.name,
                    type: card.type,
                    item: 1,
                    description: card.description,
                    text: card.text,
                    cost: card.cost,
                    isCAP: card.isCAP,
                    iconType: card.iconType,
                    battleIcon: card.battleIcon
                )
                deck.append(newCard)
            }
        }
        return deck
    }

    func drawRandomCard(ofType type: CardType) -> Card? {
        let filteredDeck = deck.filter { $0.type == type }
        guard let randomCard = filteredDeck.randomElement(),
              let index = deck.firstIndex(of: randomCard) else {
            print("No more cards of type \(type.name) available!")
            return nil
        }
        return deck.remove(at: index)
    }

    func returnCard(_ card: Card) {
        deck.append(card)
    }
}
