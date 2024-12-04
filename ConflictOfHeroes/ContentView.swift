//
//  ContentView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedHexagon: HexagonCell?
    @State var reserveUnits: [Unit] = []
    @State var removedUnits: [Unit] = []
    let missionData: MissionData? = loadMissionData(from: "mission1")
    let initialData = setupInitialUnits(for: .mission1)
    let initialCells: [HexagonCell]

    init() {
        let (cells, reserve) = setupInitialUnits(for: .mission1)
        self.initialCells = cells
        self._reserveUnits = State(initialValue: reserve)
    }

    var body: some View {
        NavigationSplitView {
            VStack {
                Section(header: Text("Reserve Units")) {
                    List(reserveUnits, id: \.self) { unit in
                        UnitRow(unit: unit)
                            .draggable(unit) {
                                Text(unit.name)
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .background(Capsule().fill(Color.white))
                            }
                    }
                }
            }
            .navigationSplitViewColumnWidth(190)
        } content: {
            if let missionData {
                HexagonGridView(
                    cells: initialCells,
                    reserveUnits: $reserveUnits,
                    removedUnits: $removedUnits,
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
                    Section(header: Text("Hexagon Units")) {
                        List(selectedHexagon.units, id: \.self) { unit in
                            UnitRow(unit: unit)
                                .draggable(unit) {
                                    Text(unit.name)
                                        .foregroundColor(.black)
                                        .padding(8)
                                        .background(Capsule().fill(Color.white))
                                }
                        }
                    }
                }

                d10SimulatorView()
                d6SimulatorView()
            }
            .navigationSplitViewColumnWidth(selectedHexagon != nil ? 190 : 0)
        }
    }
}

#Preview {
    let hitMarkerPool = HitMarkerPool(hitMarkers: loadHitMarkers(from: "HitMarkers"))
    ContentView()
        .environmentObject(hitMarkerPool)
}
