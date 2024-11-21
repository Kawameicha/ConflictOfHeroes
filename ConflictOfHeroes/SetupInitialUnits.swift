//
//  SetupInitialUnits.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 21.11.24.
//

import Foundation

func setupInitialUnits(for mission: Mission) -> [HexagonCell] {
    let statsDictionary = loadUnitStatsFromFile()
    var hexagonCells: [HexagonCell] = []

    guard let missionData = loadMissionData(from: "\(mission)") else {
        return []
    }

    let columns = 17
    let evenColumnRows = 12
    let oddColumnRows = 11

    for column in 0..<columns {
        let rows = column.isMultiple(of: 2) ? evenColumnRows : oddColumnRows
        for row in 0..<rows {
            let coordinate = HexagonCoordinate(row: row, col: column)

            var updatedCell = HexagonCell(offsetCoordinate: coordinate, units: [])

            if let missionUnit = missionData.units.first(where: { $0.hexagon == coordinate }) {
                let unit = Unit(
                    name: missionUnit.name,
                    type: missionUnit.type,
                    army: missionUnit.army,
                    orientation: missionUnit.orientation,
                    statsDictionary: statsDictionary
                )
                updatedCell.units.append(unit)
            }

            hexagonCells.append(updatedCell)
        }
    }

    return hexagonCells
}

