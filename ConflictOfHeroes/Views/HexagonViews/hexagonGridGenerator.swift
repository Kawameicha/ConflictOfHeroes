//
//  hexagonGridGenerator.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import Foundation

func hexagonGridGenerator() -> [HexagonCell] {
    var generatedCells: [HexagonCell] = []
    let columns = 17
    let evenColumnRows = 12
    let oddColumnRows = 11

    for column in 0..<columns {
        let rows = column.isMultiple(of: 2) ? evenColumnRows : oddColumnRows
        for row in 0..<rows {
            let cell = HexagonCell(offsetCoordinate: HexagonCoordinate(row: row, col: column))
            generatedCells.append(cell)
        }
    }
    return generatedCells
}
