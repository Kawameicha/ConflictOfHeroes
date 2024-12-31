//
//  SetupInitialUnits.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 21.11.24.
//

import Foundation

func setupInitialUnits(for mission: Mission) -> ([HexagonCell], [Unit], [Unit]) {
    let statsDictionary = loadUnitStatsFromFile()
    var inGameUnits: [HexagonCell] = []
    var backUpUnits: [Unit] = []
    var killedUnits: [Unit] = []

    guard let missionData = loadMissionData(from: "\(mission)") else {
        return ([], [], [])
    }

    let columns = missionData.gameSetup.cols
    let evenColumnRows = missionData.gameSetup.rows
    let oddColumnRows = evenColumnRows - 1

    for column in 0..<columns {
        let rows = column.isMultiple(of: 2) ? evenColumnRows : oddColumnRows
        for row in 0..<rows {
            let coordinate = HexagonCoordinate(row: row, col: column)

            var updatedCell = HexagonCell(offsetCoordinate: coordinate, units: [])

            let unitsOnHex = missionData.gameUnits.filter {
                $0.hexagon == coordinate && $0.state == .inGame
            }

            for gameUnit in unitsOnHex {
                let unit = Unit(
                    name: gameUnit.name,
                    army: gameUnit.army,
                    orientation: gameUnit.orientation,
                    statsDictionary: statsDictionary
                )
                updatedCell.units.append(unit)
            }

            inGameUnits.append(updatedCell)
        }
    }

    backUpUnits = missionData.gameUnits.filter { $0.state == .backUp }.map {
        Unit(
            name: $0.name,
            army: $0.army,
            orientation: $0.orientation,
            statsDictionary: statsDictionary
        )
    }

    backUpUnits.append(contentsOf: (0..<16).map { _ in
        Unit(
            name: "Smoke",
            army: .german,
            orientation: .N,
            exhausted: true,
            statsDictionary: statsDictionary
        )
    })

    killedUnits = missionData.gameUnits.filter { $0.state == .killed }.map {
        Unit(
            name: $0.name,
            army: $0.army,
            orientation: $0.orientation,
            statsDictionary: statsDictionary
        )
    }

    return (inGameUnits, backUpUnits, killedUnits)
}
