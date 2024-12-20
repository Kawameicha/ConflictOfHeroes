//
//  ConflictOfHeroesApp.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

@main
struct ConflictOfHeroesApp: App {
    @StateObject var gameManager: GameManager

    init() {
        let cards = loadFromJson(from: "Cards", ofType: Card.self)
        let hitMarkers = loadFromJson(from: "HitMarkers", ofType: HitMarker.self)
        _gameManager = StateObject(wrappedValue: GameManager(
            cardDeck: CardDeck(cards: cards),
            hitMarkerPool: HitMarkerPool(hitMarkers: hitMarkers)
        ))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(gameManager: gameManager)
                .environmentObject(gameManager)
        }
        .commands {
            GameCommands(gameManager: gameManager)
        }
    }
}
