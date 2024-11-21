//
//  ContentView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct ContentView: View {
    let initialCells: [HexagonCell] = setupInitialUnits(for: .mission1)
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
