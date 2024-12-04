//
//  ContentView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var selectedHexagon: HexagonCell?
    @State private var reserveUnits: [Unit] = []
    @State private var removedUnits: [Unit] = []
    @State private var initialCells: [HexagonCell]
    @State private var missionData: MissionData?

    init() {
        let mission = loadMissionData(from: "mission1")
        let (cells, reserve) = setupInitialUnits(for: .mission1)
        self._initialCells = State(initialValue: cells)
        self._reserveUnits = State(initialValue: reserve)
        self._missionData = State(initialValue: mission)
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
                    cells: $initialCells,
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
        .onAppear {
            gameManager.contentView = self
        }
    }

    func startNewMission(missionName: String) {
        if let newMissionData = loadMissionData(from: missionName) {
            self.missionData = newMissionData
            let (newCells, newReserve) = setupInitialUnits(for: Mission(rawValue: missionName) ?? .mission1)
            self.initialCells = newCells
            self.reserveUnits = newReserve
            self.removedUnits = []
            self.selectedHexagon = nil
        } else {
            print("Error: Could not load mission \(missionName)")
        }
    }
}

#Preview {
    let gameManager = GameManager()
    let hitMarkerPool = HitMarkerPool(hitMarkers: loadHitMarkers(from: "HitMarkers"))
    ContentView()
        .environmentObject(gameManager)
        .environmentObject(hitMarkerPool)
}
