//
//  LoadMissionData.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 21.11.24.
//

import Foundation

func loadMissionData(from filename: String) -> MissionData? {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        print("Error: Unable to load file \(filename).json")
        return nil
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(MissionData.self, from: data)
    } catch {
        print("Error decoding JSON data: \(error)")
        return nil
    }
}
