//
//  GameManager.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 04.12.24.
//

import Foundation

class GameManager: ObservableObject {
    @Published var currentMission: String?
    @Published var gameViewModel: GameViewModel
    @Published var cardDeck: CardDeck
    @Published var hitMarkerPool: HitMarkerPool

    init(cardDeck: CardDeck, hitMarkerPool: HitMarkerPool) {
        self.gameViewModel = GameViewModel()
        self.cardDeck = cardDeck
        self.hitMarkerPool = hitMarkerPool
    }

    func startNewMission(missionName: String) {
        currentMission = missionName
        gameViewModel.loadMission(missionName)
    }

    func startNewRound() {
        gameViewModel.startNewRound()
    }

    func resetGame() {
        gameViewModel.initialCells.forEach { cell in
            cell.units.forEach { unit in
                if let hitMarker = unit.hitMarker {
                    hitMarkerPool.returnHitMarker(hitMarker)
                    unit.hitMarker = nil
                }
            }
        }

        gameViewModel.germanCard.forEach { card in
            cardDeck.returnCard(card)
        }
        gameViewModel.germanCard.removeAll()

        gameViewModel.sovietCard.forEach { card in
            cardDeck.returnCard(card)
        }
        gameViewModel.sovietCard.removeAll()
    }
}
