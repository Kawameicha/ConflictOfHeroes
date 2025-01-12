//
//  GameToolbarView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 19.12.24.
//

import SwiftUI

struct GameToolbarView: View {
    @EnvironmentObject var gameManager: GameManager
    @ObservedObject var viewModel: GameViewModel

    init(gameManager: GameManager) {
        self.viewModel = gameManager.viewModel
    }

    var body: some View {
        HStack {
            Text("Round")
                .frame(width: 42)

            Picker("Round", selection: $viewModel.gameState.round) {
                ForEach(1...(viewModel.missionData?.gameSetup.last ?? 5), id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 45)

            Divider()

            Text("VPs")
                .frame(width: 25)

            Picker("Victory Points", selection: $viewModel.gameState.victoryPoints) {
                ForEach(1...10, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 45)

            Button(action: {
                viewModel.toggleVictoryMarker()
            }) {
                ZStack {
                    switch viewModel.gameState.victoryMarker {
                    case .german:
                        CrossShape(widthFactor: 0.3)
                            .foregroundColor(.black)

                        CrossShape(widthFactor: 0.25)
                            .foregroundColor(.white)

                        CrossShape(widthFactor: 0.2)
                            .foregroundColor(.black)
                    case .soviet:
                        StarShape()
                            .fill(Color.red)
                    }
                }
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 15)
            }

            Divider()

            Text("CAPs")
                .frame(width: 33)

            Picker("German CAPs", selection: $viewModel.gameState.caps.german) {
                ForEach(0...15, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 45)

            Button(action: {
                viewModel.isShowingGermanCards.toggle()
            }) {
                Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
            }
            .frame(width: 15)

            Text("x \($viewModel.germanCards.count)")

            ZStack {
                CrossShape(widthFactor: 0.3)
                    .foregroundColor(.black)

                CrossShape(widthFactor: 0.25)
                    .foregroundColor(.white)

                CrossShape(widthFactor: 0.2)
                    .foregroundColor(.black)
            }
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: 15)

            Text("-")

            Picker("Soviet CAPs", selection: $viewModel.gameState.caps.soviet) {
                ForEach(0...15, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 45)

            Button(action: {
                viewModel.isShowingSovietCards.toggle()
            }) {
                Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
            }
            .frame(width: 15)

            Text("x \($viewModel.sovietCards.count)")

            ZStack {
                StarShape()
                    .fill(Color.red)
            }
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: 15)
        }
    }
}
