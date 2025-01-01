//
//  PlayerHandView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 22.12.24.
//

import SwiftUI

struct PlayerHandView: View {
    @EnvironmentObject var gameManager: GameManager
    @Binding var cards: [Card]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Player Hand")
                .font(.headline)
                .padding(.bottom, 8)

            Button(action: {
                if let card = gameManager.cardDeck.drawRandomCard(ofType: .battle) {
                    cards.append(card)
                } else {
                    print("No battle cards are available!")
                }
            }) {
                Label("Draw Card", systemImage: "plus.circle")
                    .padding()
                    .background(Capsule().fill(Color.blue.opacity(0.2)))
            }
            .buttonStyle(BorderlessButtonStyle())

            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 8) {
                    ForEach(cards, id: \.id) { card in
                        CardView(card: card)
                            .contextMenu {
                                Menu("Return to") {
                                    Button("Reserve") {
                                        gameManager.cardDeck.returnCard(card)
                                        if let index = cards.firstIndex(where: { $0.id == card.id }) {
                                            cards.remove(at: index)
                                        }
                                    }
                                }

                                Divider()
                                
                                Menu("Debug") {
                                    Button("Print CardDeck") {
                                        print("CardDeck contents: \(gameManager.cardDeck.deck.map(\.name)), CardDeck items: \(gameManager.cardDeck.deck.count)")
                                    }
                                }
                            }
                    }
                }
            }
            .frame(height: 500)
        }
        .padding()
        .frame(width: 400)
    }
}
