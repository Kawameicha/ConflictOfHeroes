//
//  LoadUnitStats.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 18.11.24.
//

import Foundation

func loadUnitStats(from data: Data) -> [UnitIdentifier: UnitStats] {
    do {
        let statsArray = try JSONDecoder().decode([UnitStats].self, from: data)
        let statsDictionary = Dictionary(uniqueKeysWithValues: statsArray.map { ($0.identifier, $0) })

        return statsDictionary
    } catch {
        print("Error decoding UnitStats: \(error)")
        return [:]
    }
}

func loadUnitStatsFromFile() -> [UnitIdentifier: UnitStats] {
    guard let fileURL = Bundle.main.url(forResource: "UnitStats", withExtension: "json") else {
        print("UnitStats.json file not found")
        return [:]
    }

    do {
        let data = try Data(contentsOf: fileURL)
        return loadUnitStats(from: data)
    } catch {
        print("Error loading UnitStats.json: \(error)")
        return [:]
    }
}
