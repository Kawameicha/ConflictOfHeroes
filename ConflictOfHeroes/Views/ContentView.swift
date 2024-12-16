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
    @State private var victoryPoints: Int = 0
    @State private var germanCAP: Int = 0
    @State private var sovietCAP: Int = 0
    @State private var leading: UnitArmy = .german

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
                GroupBox(
                    label: Text("\(missionData?.gameSetup.name ?? "") - \(missionData?.gameSetup.date ?? "")")
                ) {
                    HStack {
                        Text("Leading: \(leading.rawValue.capitalized)")
                        Spacer()
                        Button(action: {
                            leading = (leading == .german) ? .soviet : .german
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }

                    HStack {
                        Text("Victory Points: ")
                        Spacer()
                        Button(action: { victoryPoints -= 1 }) {
                            Image(systemName: "minus")
                        }
                        Text("\(victoryPoints)")
                        Button(action: { victoryPoints += 1 }) {
                            Image(systemName: "plus")
                        }
                    }

                    HStack {
                        Text("German CAP: ")
                        Spacer()
                        Button(action: { germanCAP -= 1 }) {
                            Image(systemName: "minus")
                        }
                        Text("\(germanCAP)")
                        Button(action: { germanCAP += 1 }) {
                            Image(systemName: "plus")
                        }
                    }

                    HStack {
                        Text("Soviet CAP: ")
                        Spacer()
                        Button(action: { sovietCAP -= 1 }) {
                            Image(systemName: "minus")
                        }
                        Text("\(sovietCAP)")
                        Button(action: { sovietCAP += 1 }) {
                            Image(systemName: "plus")
                        }
                    }
                }.padding()

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
                    maps: missionData.gameSetup.maps,
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
