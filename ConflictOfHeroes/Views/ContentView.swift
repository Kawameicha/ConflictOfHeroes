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
        self.viewModel = gameManager.gameViewModel
    }

    var body: some View {
        NavigationSplitView {
            VStack {
                if let selectedHexagon = viewModel.selectedHexagon {
                    HexagonCellView(hexagon: selectedHexagon)
                }

                d10SimulatorView()
                d6SimulatorView()
            }
//            .toolbar(removing: .sidebarToggle)
            .navigationSplitViewColumnWidth(190)
        } detail: {
            if let missionData = viewModel.missionData {
                HexagonGridView(
                    cells: $viewModel.initialCells,
                    reserveUnits: $viewModel.reserveUnits,
                    removedUnits: $viewModel.removedUnits,
                    maps: missionData.gameSetup.maps,
                    onHexagonSelected: { hexagon in
                        viewModel.selectedHexagon = hexagon
                    }
                )
            } else {
                Text("Please select a mission in the menu")
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    viewModel.isShowingReserveUnits.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }

            ToolbarItem(placement: .status) {
                GameToolbarView(
                    round: $viewModel.round,
                    roundLimit: $viewModel.roundLimit,
                    victoryPoints: $viewModel.victoryPoints,
                    germanCAP: $viewModel.germanCAP,
                    sovietCAP: $viewModel.sovietCAP,
                    leading: $viewModel.leading,
                    isShowGermanCards: $viewModel.isShowGermanCards,
                    isShowSovietCards: $viewModel.isShowSovietCards
                )
            }
        }
        .popover(isPresented: $viewModel.isShowingReserveUnits, attachmentAnchor: .point(.top)) {
            ReserveUnitView(reserveUnits: viewModel.reserveUnits)
        }
        .popover(isPresented: $viewModel.isShowGermanCards, attachmentAnchor: .point(.top)) {
            PlayerHandView(cards: $viewModel.germanCard)
        }
        .popover(isPresented: $viewModel.isShowSovietCards, attachmentAnchor: .point(.top)) {
            PlayerHandView(cards: $viewModel.sovietCard)
        }
        .navigationTitle(Text("\(viewModel.missionData?.gameSetup.name ?? "") - \(viewModel.missionData?.gameSetup.date ?? "")"))
    }
}

#Preview {
    let hitMarkerPool = HitMarkerPool(hitMarkers: loadFromJson(from: "HitMarkers", ofType: HitMarker.self))
    let cardDeck = CardDeck(cards: loadFromJson(from: "Cards", ofType: Card.self))
    let gameManager = GameManager(cardDeck: cardDeck, hitMarkerPool: hitMarkerPool)

    ContentView(gameManager: gameManager)
}
