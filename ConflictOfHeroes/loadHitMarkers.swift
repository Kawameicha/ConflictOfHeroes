//
//  loadHitMarkers.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 02.12.24.
//

import Foundation

func loadHitMarkers(from fileName: String) -> [HitMarker] {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("File not found: \(fileName).json")
        return []
    }

    do {
        let data = try Data(contentsOf: url)
        let hitMarkers = try JSONDecoder().decode([HitMarker].self, from: data)
        return hitMarkers
    } catch {
        print("Failed to load or decode \(fileName).json: \(error)")
        return []
    }
}
