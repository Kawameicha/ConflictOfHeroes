//
//  ContentView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @ObservedObject var viewModel: GameViewModel

    init(gameManager: GameManager) {
        self.viewModel = gameManager.viewModel
    }

    var body: some View {
        NavigationSplitView {
            VStack {
                if let selectedHex = viewModel.selectedHex {
                    HexagonCellView(hexagon: selectedHex)
                }

                Spacer()

                d10SimulatorView()
                d6SimulatorView()
            }
//            .toolbar(removing: .sidebarToggle)
            .navigationSplitViewColumnWidth(160)
        } detail: {
            if let missionData = viewModel.missionData {
                HexagonGridView(
                    inGameUnits: $viewModel.inGameUnits,
                    backUpUnits: $viewModel.backUpUnits,
                    killedUnits: $viewModel.killedUnits,
                    maps: missionData.gameSetup.maps,
                    onHexagonSelected: { hexagon in
                        viewModel.selectedHex = hexagon
                    }
                )
            } else {
                Text("Please select a mission in the menu")
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    gameManager.startMatch()
                }) {
                    Image(systemName: "network")
                }

                Button(action: {
                    if let match = gameManager.match {
                        print("Match found: \(match.matchID)")
                        gameManager.endTurn(for: match)
                    } else {
                        print("No match found or current participant is missing.")
                    }
                }) {
                    Image(systemName: "checkmark.bubble")
                }
            }

            ToolbarItem(placement: .status) {
                GameToolbarView(gameManager: gameManager)
            }
        }
        .popover(isPresented: $viewModel.isShowingKilledUnits, attachmentAnchor: .point(.top)) {
            GameUnitView(units: viewModel.killedUnits)
        }
        .popover(isPresented: $viewModel.isShowingBackUpUnits, attachmentAnchor: .point(.top)) {
            GameUnitView(units: viewModel.backUpUnits)
        }
        .popover(isPresented: $viewModel.isShowingGermanCards, attachmentAnchor: .point(.top)) {
            PlayerHandView(cards: $viewModel.germanCards)
        }
        .popover(isPresented: $viewModel.isShowingSovietCards, attachmentAnchor: .point(.top)) {
            PlayerHandView(cards: $viewModel.sovietCards)
        }
        .navigationTitle(Text("\(viewModel.missionData?.gameSetup.name ?? "") - \(viewModel.missionData?.gameSetup.date ?? "")"))
    }
}

#Preview {
    let hitMarkerPool = HitMarkerPool(hitMarkers: loadFromJson(from: "HitMarkers", ofType: HitMarker.self))
    let cardDeck = CardDeck(cards: loadFromJson(from: "Cards", ofType: Card.self))
    let gameManager = GameManager(cardDeck: cardDeck, hitMarkerPool: hitMarkerPool)

    ContentView(gameManager: gameManager)
        .environmentObject(gameManager)
}
