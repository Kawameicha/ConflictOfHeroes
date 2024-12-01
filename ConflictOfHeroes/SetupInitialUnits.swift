//
//  SetupInitialUnits.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 21.11.24.
//

import Foundation

func setupInitialUnits(for mission: Mission) -> ([HexagonCell], [Unit]) {
    let statsDictionary = loadUnitStatsFromFile()
    var hexagonCells: [HexagonCell] = []
    var reserveUnits: [Unit] = []

    guard let missionData = loadMissionData(from: "\(mission)") else {
        return ([], [])
    }

    let columns = missionData.metadata.columns
    let evenColumnRows = missionData.metadata.evenColumnRows
    let oddColumnRows = missionData.metadata.oddColumnRows

    for column in 0..<columns {
        let rows = column.isMultiple(of: 2) ? evenColumnRows : oddColumnRows
        for row in 0..<rows {
            let coordinate = HexagonCoordinate(row: row, col: column)

            var updatedCell = HexagonCell(offsetCoordinate: coordinate, units: [])

            if let missionUnit = missionData.units.first(where: { $0.hexagon == coordinate && $0.isReserve == false }) {
                let unit = Unit(
                    name: missionUnit.name,
                    army: missionUnit.army,
                    orientation: missionUnit.orientation,
                    statsDictionary: statsDictionary
                )
                updatedCell.units.append(unit)
            }

            hexagonCells.append(updatedCell)
        }
    }

    reserveUnits = missionData.units.filter { $0.isReserve }.map {
        Unit(
            name: $0.name,
            army: $0.army,
            orientation: $0.orientation,
            statsDictionary: statsDictionary
        )
    }

    return (hexagonCells, reserveUnits)
}

