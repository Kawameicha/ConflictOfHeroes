//
//  ContentView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct ContentView: View {
    let missionData: MissionData? = loadMissionData(from: "mission0")
    let initialCells: [HexagonCell] = setupInitialUnits(for: .mission0)
    var allUnits: [Unit] {
            initialCells.flatMap { $0.units }
        }

    var body: some View {
        NavigationSplitView {
            VStack {
                List(allUnits, id: \.self) { unit in
                    UnitRow(unit: unit)
                        .draggable(unit) {
                            Text(unit.name)
                                .foregroundColor(.black)
                                .padding(8)
                                .background(Capsule().fill(Color.white))
                        }
                }

                Spacer()

                DiceSimulatorView()
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            if let missionData {
                HexagonGridView(cells: initialCells, mapName: missionData.metadata.mapName)
            } else {
                Text("Error loading mission data")
            }
        }
    }
}

#Preview {
    ContentView()
}
