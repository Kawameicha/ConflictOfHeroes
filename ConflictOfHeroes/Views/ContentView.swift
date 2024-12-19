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
    @State var initialCells: [HexagonCell]
    @State private var missionData: MissionData?
    @State var round: Int = 1
    @State private var roundLimit: Int = 5
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
                if let selectedHexagon {
                    HexagonCellView(hexagon: selectedHexagon)
                }

                d10SimulatorView()
                d6SimulatorView()
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
                GameToolbarView(
                    round: $round,
                    roundLimit: $roundLimit,
                    victoryPoints: $victoryPoints,
                    germanCAP: $germanCAP,
                    sovietCAP: $sovietCAP,
                    leading: $leading
                )
            }
        }
        .popover(isPresented: $isShowingReserveUnits, attachmentAnchor: .point(.top)) {
            ReserveUnitsView(reserveUnits: reserveUnits)
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
                self.roundLimit = missionData.gameSetup.rounds
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
            self.round = 1
            self.roundLimit = newMissionData.gameSetup.rounds
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
