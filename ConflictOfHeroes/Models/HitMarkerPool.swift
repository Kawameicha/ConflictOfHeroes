//
//  HitMarkerPool.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 03.12.24.
//

import SwiftUI

class HitMarkerPool: ObservableObject {
    @Published var pool: [HitMarker] = []

    init(hitMarkers: [HitMarker]) {
        self.pool = Self.createHitMarkerPool(from: hitMarkers)
    }

    static func createHitMarkerPool(from hitMarkers: [HitMarker]) -> [HitMarker] {
        var pool: [HitMarker] = []
        for hitMarker in hitMarkers {
            pool.append(contentsOf: Array(repeating: hitMarker, count: hitMarker.item))
        }
        return pool
    }

    func assignRandomSoftHitMarker() -> HitMarker? {
        assignRandomHitMarker(ofType: .soft)
    }

    func assignRandomHardHitMarker() -> HitMarker? {
        assignRandomHitMarker(ofType: .hard)
    }

    func returnHitMarker(_ hitMarker: HitMarker) {
        pool.append(hitMarker)
    }

    func assignRandomHitMarker(ofType type: HitMarkerType) -> HitMarker? {
        let filteredPool = pool.filter { $0.type == type }
        guard !filteredPool.isEmpty else {
            print("No more \(type.rawValue) hit markers available!")
            return nil
        }

        if let randomMarker = filteredPool.randomElement(),
           let index = pool.firstIndex(of: randomMarker) {
            return pool.remove(at: index)
        }

        return nil
    }
}
