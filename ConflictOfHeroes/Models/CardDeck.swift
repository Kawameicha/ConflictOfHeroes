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
            deck.append(contentsOf: Array(repeating: card, count: card.item))
        }
        return deck
    }

    func drawRandomCard(ofType type: CardType? = nil) -> Card? {
        if let type = type {
            let filteredDeck = deck.filter { $0.type == type }
            guard let randomCard = filteredDeck.randomElement(),
                  let index = deck.firstIndex(of: randomCard) else {
                print("No more cards of type \(type.name) available!")
                return nil
            }
            return deck.remove(at: index)
        } else {
            guard let randomCard = deck.randomElement(),
                  let index = deck.firstIndex(of: randomCard) else {
                print("Deck is empty!")
                return nil
            }
            return deck.remove(at: index)
        }
    }

    func returnCard(_ card: Card) {
        deck.append(card)
    }

    func shuffle() {
        deck.shuffle()
    }
}
