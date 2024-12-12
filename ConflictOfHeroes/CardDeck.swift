class CardDeck: ObservableObject {
    @Published var deck: [Card] = []

    init(cards: [Card]) {
        self.deck = Self.createCardDeck(from: cards)
    }

    /// Initializes the deck by creating the specified number of copies of each card.
    private static func createCardDeck(from cards: [Card]) -> [Card] {
        var deck: [Card] = []
        for card in cards {
            deck.append(contentsOf: Array(repeating: card, count: card.item))
        }
        return deck
    }

    /// Draws a random card of the specified type.
    func drawRandomCard(ofType type: CardType? = nil) -> Card? {
        if let type = type {
            let filteredDeck = deck.filter { $0.cardType == type }
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

    /// Returns a card back to the deck.
    func returnCard(_ card: Card) {
        deck.append(card)
    }

    /// Shuffles the deck.
    func shuffle() {
        deck.shuffle()
    }
}