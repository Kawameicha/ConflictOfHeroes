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
            Button("Start Mission 1") {
                gameManager.startNewMission(missionName: "mission1")
            }
            .keyboardShortcut("1", modifiers: [.command])

            Button("Start Mission 2") {
                gameManager.startNewMission(missionName: "mission2")
            }
            .keyboardShortcut("2", modifiers: [.command])
        }
    }
}
