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
    @StateObject var hitMarkerPool = HitMarkerPool(hitMarkers: loadHitMarkers(from: "HitMarkers"))

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameManager)
                .environmentObject(hitMarkerPool)
        }
        .commands {
            GameCommands(gameManager: gameManager)
        }
    }
}

struct GameCommands: Commands {
    var gameManager: GameManager

    var body: some Commands {
        CommandGroup(after: .saveItem) {
            Button("Start Mission 1") {
                gameManager.startNewMission(missionName: "mission1")
            }
            .keyboardShortcut("1", modifiers: [.command])

            Button("Start Mission 2") {
                gameManager.startNewMission(missionName: "mission0")
            }
            .keyboardShortcut("2", modifiers: [.command])
        }
    }
}
