//
//  ContentView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedHexagon: HexagonCell?
    let missionData: MissionData? = loadMissionData(from: "mission0")
    let initialCells: [HexagonCell] = setupInitialUnits(for: .mission0)

    var body: some View {
        NavigationSplitView {
            VStack {
                d10SimulatorView()
                d6SimulatorView()
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } content: {
            if let missionData {
                HexagonGridView(
                    cells: initialCells,
                    mapName: missionData.metadata.mapName,
                    onHexagonSelected: { hexagon in
                        selectedHexagon = hexagon
                    }
                )
            } else {
                Text("Error loading mission data")
            }
        } detail: {
            VStack {
                if let selectedHexagon {
                    List(selectedHexagon.units, id: \.self) { unit in
                        UnitRow(unit: unit)
                            .draggable(unit) {
                                Text(unit.name)
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .background(Capsule().fill(Color.white))
                            }
                    }
                    .navigationTitle("Units in Hexagon")
                } else {
                    Text("Select a hexagon to view its units")
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        }
    }
}

#Preview {
    ContentView()
}
