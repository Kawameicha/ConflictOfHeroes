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
            for _ in 0..<hitMarker.item {
                let newMarker = HitMarker(
                    code: hitMarker.code,
                    name: hitMarker.name,
                    type: hitMarker.type,
                    item: 1,
                    rally: hitMarker.rally,
                    attackCost: hitMarker.attackCost,
                    attackSoft: hitMarker.attackSoft,
                    attackHard: hitMarker.attackHard,
                    attackDisabled: hitMarker.attackDisabled,
                    gunDamaged: hitMarker.gunDamaged,
                    moveCost: hitMarker.moveCost,
                    moveDisabled: hitMarker.moveDisabled,
                    defenseFlank: hitMarker.defenseFlank,
                    defenseFront: hitMarker.defenseFront,
                    rangeDisabled: hitMarker.rangeDisabled
                )
                pool.append(newMarker)
            }
        }
        return pool
    }

    func assignRandomHitMarker(ofType type: HitMarkerType) -> HitMarker? {
        let filteredPool = pool.filter { $0.type == type }
        guard let randomMarker = filteredPool.randomElement(),
              let index = pool.firstIndex(of: randomMarker) else {
            print("No more \(type.rawValue) hit markers available!")
            return nil
        }
        return pool.remove(at: index)
    }

    func returnHitMarker(_ hitMarker: HitMarker) {
        pool.append(hitMarker)
    }
}
