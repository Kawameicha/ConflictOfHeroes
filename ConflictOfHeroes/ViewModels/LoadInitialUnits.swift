//
//  LoadInitialUnits.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 11.01.25.
//

import Foundation

func loadInitialUnits(for mission: Mission, missionData: MissionData) -> ([HexagonCell], [Unit], [Unit]) {
        var inGameUnits: [HexagonCell] = []
        var backUpUnits: [Unit] = []
        var killedUnits: [Unit] = []

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
                        hexagon: gameUnit.hexagon,
                        orientation: gameUnit.orientation,
                        exhausted: gameUnit.exhausted,
                        hitMarker: gameUnit.hitMarker,
                        stressed: gameUnit.stressed,
                        state: gameUnit.state,
                        statsDictionary: [:]
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
                hexagon: $0.hexagon,
                orientation: $0.orientation,
                exhausted: $0.exhausted,
                hitMarker: $0.hitMarker,
                stressed: $0.stressed,
                state: $0.state,
                statsDictionary: [:]
            )
        }

        killedUnits = missionData.gameUnits.filter { $0.state == .killed }.map {
            Unit(
                name: $0.name,
                army: $0.army,
                hexagon: $0.hexagon,
                orientation: $0.orientation,
                exhausted: $0.exhausted,
                hitMarker: $0.hitMarker,
                stressed: $0.stressed,
                state: $0.state,
                statsDictionary: [:]
            )
        }

        return (inGameUnits, backUpUnits, killedUnits)
    }
