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
            Button("Save Mission") {
                saveGame()
            }
            .keyboardShortcut("S", modifiers: [.command])

            Button("Load Mission") {
                loadGame()
            }
            .keyboardShortcut("L", modifiers: [.command])
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

    private func saveGame() {
        let savePanel = NSSavePanel()
        savePanel.title = "Save Mission As..."
        savePanel.message = "Choose a location to save the mission file."
        savePanel.nameFieldStringValue = "Mission.json"
        savePanel.allowedContentTypes = [.json]

        if savePanel.runModal() == .OK, let selectedFileURL = savePanel.url {
            gameManager.saveMission(to: selectedFileURL)
        } else {
            print("User canceled file save.")
        }
    }

    private func loadGame() {
        let openPanel = NSOpenPanel()
        openPanel.title = "Select a Mission File"
        openPanel.message = "Choose a JSON file to load the mission."
        openPanel.allowedContentTypes = [.json]
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false

        if openPanel.runModal() == .OK, let selectedFileURL = openPanel.url {
            do {
                let jsonData = try Data(contentsOf: selectedFileURL)
                if let loadedMission = try? JSONDecoder().decode(MissionData.self, from: jsonData) {
                    gameManager.loadMission(missionData: loadedMission)
                    print("Mission loaded successfully from \(selectedFileURL.path)")
                } else {
                    print("Failed to decode mission data.")
                }
            } catch {
                print("Error loading mission: \(error.localizedDescription)")
            }
        } else {
            print("User canceled file selection.")
        }
    }
}
