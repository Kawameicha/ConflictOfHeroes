//
//  ContentView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct ContentView: View {
    let initialCells: [HexagonCell] = hexagonGridGenerator().map { cell in
        var updatedCell = cell
        let statsDictionary = loadUnitStatsFromFile()

        if cell.offsetCoordinate == HexagonCoordinate(row: 0, col: 0) {
            updatedCell.units = [Unit(name: "Rifles '41", type: .foot, army: .german, orientation: .SE, statsDictionary: statsDictionary)]
        } else if cell.offsetCoordinate == HexagonCoordinate(row: 2, col: 2) {
            updatedCell.units = [Unit(name: "Rifles '41", type: .foot, army: .soviet, orientation: .NW, statsDictionary: statsDictionary)]
        } else if cell.offsetCoordinate == HexagonCoordinate(row: 1, col: 2) {
            updatedCell.units = [Unit(name: "Control", type: .control, army: .soviet, statsDictionary: statsDictionary)]
        }
        return updatedCell
    }
    var allUnits: [Unit] {
            initialCells.flatMap { $0.units }
        }

    var body: some View {
        NavigationSplitView {
            List(allUnits, id: \.self) { unit in
                Text(unit.name)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            HexagonGridView(cells: initialCells)
        }
    }
}

#Preview {
    ContentView()
}
