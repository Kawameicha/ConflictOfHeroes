//
//  LoadFromFile.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 12.12.24.
//

import Foundation

func loadFromJson<T: Codable>(from fileName: String, ofType type: T.Type) -> [T] {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("File not found: \(fileName).json")
        return []
    }

    do {
        let data = try Data(contentsOf: url)
        let decodedData = try JSONDecoder().decode([T].self, from: data)
        return decodedData
    } catch {
        print("Failed to load or decode \(fileName).json: \(error)")
        return []
    }
}
