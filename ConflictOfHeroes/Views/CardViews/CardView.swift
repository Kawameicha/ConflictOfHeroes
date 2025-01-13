//
//  CardView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 19.12.24.
//

import SwiftUI

struct CardView: View {
    var card: Card

    var body: some View {
        GroupBox {
            ZStack {
                VStack {
                    VStack(alignment: .trailing) {
                        Text(card.name)
                            .font(.headline)
                        Text(card.description)
                            .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                VStack {
                    Image("\(card.code)")
                        .resizable()
                        .scaledToFit()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .offset(y: -33)
                .padding(.horizontal, -4)

                VStack {
                    Text(card.text)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .offset(y: 66)
                .padding(.horizontal, 16)

                VStack(spacing: 96) {
                    if card.iconType == .action {
                        Image(systemName: "bolt.square.fill")
                            .font(.system(size: 24))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.black, .wheeled)
                    } else if card.iconType == .bonus {
                        Image(systemName: "plus.square.fill")
                            .font(.system(size: 24))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.black, .indigo)
                    }

                    Image(systemName: "\(card.cost ?? 0).square.fill")
                        .font(.system(size: 33))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, card.isCAP ?? false ? .blue : .wheeled)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                VStack {
                    Text(card.code)
                        .font(.system(size: 12))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                HStack {
                    if card.battleIcon.contains(.groups) {
                        Image(systemName: "person.2.circle.fill")
                            .font(.system(size: 16))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .indigo)
                    }
                    if card.battleIcon.contains(.hidden) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 16))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .foot)
                    }
                    if card.battleIcon.contains(.explosive) {
                        Image(systemName: "flame.circle.fill")
                            .font(.system(size: 16))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.yellow, .red)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .padding(4)
            .font(.system(size: 9))
            .fontWeight(.bold)
            .foregroundStyle(.black)
            .frame(width: 175, height: 250)
            .background(
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(.white)
            )
        }
    }
}

/// Preview
struct CardGridView: View {
    let cards: [Card]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(cards, id: \.id) { card in
                    CardView(card: card)
                }
            }
            .frame(width: 840, height: .infinity)
        }
        .navigationTitle("Cards")
    }
}

#Preview {
    let cards = loadFromJson(from: "Cards", ofType: Card.self)
    CardGridView(cards: cards)
}
