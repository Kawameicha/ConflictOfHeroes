//
//  ContentView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cardDeck: CardDeck
    @EnvironmentObject var gameManager: GameManager
    @State private var selectedHexagon: HexagonCell?
    @State private var reserveUnits: [Unit] = []
    @State private var removedUnits: [Unit] = []
    @State private var initialCells: [HexagonCell]
    @State private var missionData: MissionData?
    @State private var round: Int = 1
    @State private var victoryPoints: Int = 0
    @State private var germanCAP: Int = 0
    @State private var sovietCAP: Int = 0
    @State private var leading: UnitArmy = .german
    @State private var isShowingReserveUnits: Bool = false

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
            }
//            .toolbar(removing: .sidebarToggle)
            .navigationSplitViewColumnWidth(190)
        } detail: {
            if let missionData {
                HexagonGridView(
                    cells: $initialCells,
                    reserveUnits: $reserveUnits,
                    removedUnits: $removedUnits,
                    maps: missionData.gameSetup.maps,
                    onHexagonSelected: { hexagon in
                        selectedHexagon = hexagon
                    }
                )
            } else {
                Text("Error loading mission data")
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    isShowingReserveUnits.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .status) {
                GroupBox {
                    HStack {
                        Text("Round")
                            .frame(width: 42)

                        Picker("Round", selection: $round) {
                            ForEach(1...7, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 45)

                        Divider()

                        Text("VPs")
                            .frame(width: 25)

                        Picker("Victory Points", selection: $victoryPoints) {
                            ForEach(1...10, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 45)

                        Button(action: {
                            leading = (leading == .german) ? .soviet : .german
                        }) {
                            ZStack {
                                switch leading {
                                case .german:
                                    CrossShape(widthFactor: 0.3)
                                        .foregroundColor(.black)

                                    CrossShape(widthFactor: 0.25)
                                        .foregroundColor(.white)

                                    CrossShape(widthFactor: 0.2)
                                        .foregroundColor(.black)
                                case .soviet:
                                    StarShape()
                                        .fill(Color.red)
                                }
                            }
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 15)
                        }

                        Divider()

                        Text("CAPs")
                            .frame(width: 33)

                        Picker("German CAPs", selection: $germanCAP) {
                            ForEach(0...15, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 45)

                        ZStack {
                            CrossShape(widthFactor: 0.3)
                                .foregroundColor(.black)

                            CrossShape(widthFactor: 0.25)
                                .foregroundColor(.white)

                            CrossShape(widthFactor: 0.2)
                                .foregroundColor(.black)
                        }
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 15)

                        Text("-")

                        Picker("Soviet CAPs", selection: $sovietCAP) {
                            ForEach(0...15, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 45)

                        ZStack {
                            StarShape()
                                .fill(Color.red)
                        }
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 15)
                    }
                }
            }
        }
        .popover(isPresented: $isShowingReserveUnits, arrowEdge: .top) {
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
            .frame(width: 190, height: 300)
        }
        .navigationTitle(Text("\(missionData?.gameSetup.name ?? "") - \(missionData?.gameSetup.date ?? "")"))
        .onAppear {
            gameManager.contentView = self

            let cards = loadFromJson(from: "Cards", ofType: Card.self)
            if cardDeck.deck.isEmpty {
                print("No cards loaded!")
                cardDeck.deck = CardDeck.createCardDeck(from: cards)
                print("Successfully loaded \(cardDeck.deck.count) cards.")
                if let card = cardDeck.drawRandomCard() {
                    print(card.name)
                }
            }

            if let missionData {
                self.victoryPoints = missionData.gameState.victoryPoints
                self.germanCAP = missionData.gameState.germanCommandPoints
                self.sovietCAP = missionData.gameState.sovietCommandPoints
                self.leading = missionData.gameState.victoryMarker
            }
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
            self.victoryPoints = newMissionData.gameState.victoryPoints
            self.germanCAP = newMissionData.gameState.germanCommandPoints
            self.sovietCAP = newMissionData.gameState.sovietCommandPoints
            self.leading = newMissionData.gameState.victoryMarker
        } else {
            print("Error: Could not load mission \(missionName)")
        }
    }
}

#Preview {
    let gameManager = GameManager()
    let hitMarkerPool = HitMarkerPool(hitMarkers: loadFromJson(from: "HitMarkers", ofType: HitMarker.self))
    let cardDeck = CardDeck(cards: loadFromJson(from: "cards", ofType: Card.self))
    ContentView()
        .environmentObject(gameManager)
        .environmentObject(hitMarkerPool)
        .environmentObject(cardDeck)
}
