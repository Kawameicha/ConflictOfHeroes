//
//  ConflictOfHeroesApp.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

@main
struct ConflictOfHeroesApp: App {
    @StateObject var hitMarkerPool = HitMarkerPool(hitMarkers: loadHitMarkers(from: "HitMarkers"))

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(hitMarkerPool)
        }
    }
}
