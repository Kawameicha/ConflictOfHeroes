//
//  ConflictOfHeroesApp.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

@main
struct ConflictOfHeroesApp: App {
    @StateObject var gameManager = GameManager()
    @StateObject var hitMarkerPool = HitMarkerPool(hitMarkers: loadFromJson(from: "HitMarkers", ofType: HitMarker.self))
    @StateObject var cardDeck = CardDeck(cards: loadFromJson(from: "Cards", ofType: Card.self))

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameManager)
                .environmentObject(hitMarkerPool)
                .environmentObject(cardDeck)
        }
        .commands {
            GameCommands(gameManager: gameManager)
        }
    }
}
