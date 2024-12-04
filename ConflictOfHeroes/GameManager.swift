//
//  GameManager.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 04.12.24.
//

import Foundation

class GameManager: ObservableObject {
    @Published var contentView: ContentView?
    @Published var currentMission: String?

    func startNewMission(missionName: String) {
        currentMission = missionName
        contentView?.startNewMission(missionName: missionName)
    }
}
