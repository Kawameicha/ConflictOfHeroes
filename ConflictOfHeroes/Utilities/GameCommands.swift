//
//  GameCommands.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 05.12.24.
//

import SwiftUI

struct GameCommands: Commands {
    var gameManager: GameManager

    var body: some Commands {
        CommandGroup(after: .saveItem) {

        }

        CommandMenu("Game") {
            Menu("Start Mission") {
                Button("Mission 1") {
                    gameManager.resetGame()
                    gameManager.startNewMission(missionName: "mission1")
                }
                .keyboardShortcut("1", modifiers: [.command])

                Button("Mission 2") {
                    gameManager.resetGame()
                    gameManager.startNewMission(missionName: "mission2")
                }
                .keyboardShortcut("2", modifiers: [.command])

                Button("Mission 3") {
                    gameManager.resetGame()
                    gameManager.startNewMission(missionName: "mission3")
                }
                .keyboardShortcut("3", modifiers: [.command])

                Button("Mission 4") {
                    gameManager.resetGame()
                    gameManager.startNewMission(missionName: "mission4")
                }
                .keyboardShortcut("4", modifiers: [.command])
            }

            Divider()

            Button("Start New Round") {
                gameManager.startNewRound()
            }
            .keyboardShortcut("R", modifiers: [.command])
        }
    }
}
