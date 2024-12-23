//
//  GameManager.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 04.12.24.
//

import Foundation

class GameManager: ObservableObject {
    @Published var viewModel: GameViewModel
    @Published var cardDeck: CardDeck
    @Published var hitMarkerPool: HitMarkerPool

    init(cardDeck: CardDeck, hitMarkerPool: HitMarkerPool) {
        self.viewModel = GameViewModel()
        self.cardDeck = cardDeck
        self.hitMarkerPool = hitMarkerPool
    }

    func startNewMission(missionName: String) {
        viewModel.loadMission(missionName)

        guard let missionData = viewModel.missionData else {
            print("Mission data is not available!")
            return
        }

        drawCards(for: &viewModel.germanCards, number: missionData.gameState.germanBattleCards.startWith)
        drawCards(for: &viewModel.sovietCards, number: missionData.gameState.sovietBattleCards.startWith)
    }

    func startNewRound() {
        viewModel.startNewRound()

        drawCards(for: &viewModel.germanCards, number: viewModel.germanCardPerRound)
        drawCards(for: &viewModel.sovietCards, number: viewModel.sovietCardPerRound)
    }

    func resetGame() {
        resetHitMarkers(in: viewModel.initialCells)
        resetCards(&viewModel.germanCards)
        resetCards(&viewModel.sovietCards)
    }

    private func drawCards(for playerCards: inout [Card], number: Int) {
        for _ in 0..<number {
            if let card = cardDeck.drawRandomCard(ofType: .battle) {
                playerCards.append(card)
            } else {
                print("No more battle cards are available!")
                break
            }
        }
    }

    private func resetHitMarkers(in cells: [HexagonCell]) {
        cells.forEach { cell in
            cell.units.forEach { unit in
                if let hitMarker = unit.hitMarker {
                    hitMarkerPool.returnHitMarker(hitMarker)
                    unit.hitMarker = nil
                }
            }
        }
    }

    private func resetCards(_ cards: inout [Card]) {
        cards.forEach { cardDeck.returnCard($0) }
        cards.removeAll()
    }
}
