//
//  HitMarkerPool 2.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 03.12.24.
//

import SwiftUI

class HitMarkerPool: ObservableObject {
    @Published var pool: [HitMarker] = []

    init(hitMarkers: [HitMarker]) {
        self.pool = hitMarkers
    }

    func assignRandomHitMarker() -> HitMarker? {
        guard !pool.isEmpty else {
            print("No more hit markers available!")
            return nil
        }

        return pool.remove(at: Int.random(in: 0..<pool.count))
    }

    func returnHitMarker(_ hitMarker: HitMarker) {
        pool.append(hitMarker)
    }

    func remainingMarkers() -> Int {
        return pool.count
    }
}
