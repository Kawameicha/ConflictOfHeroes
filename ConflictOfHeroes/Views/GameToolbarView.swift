//
//  GameToolbarView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 19.12.24.
//

import SwiftUI

struct GameToolbarView: View {
    @Binding var round: Int
    @Binding var roundLimit: Int
    @Binding var victoryPoints: Int
    @Binding var germanCAP: Int
    @Binding var sovietCAP: Int
    @Binding var leading: UnitArmy

    var body: some View {
        GroupBox {
            HStack {
                Text("Round")
                    .frame(width: 42)

                Picker("Round", selection: $round) {
                    ForEach(1...roundLimit, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 45)

                Divider()

                Text("VPs")
                    .frame(width: 25)

                Picker("Victory Points", selection: $victoryPoints) {
                    ForEach(1...10, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 45)

                Button(action: {
                    leading = (leading == .german) ? .soviet : .german
                }) {
                    ZStack {
                        switch leading {
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

                Picker("German CAPs", selection: $germanCAP) {
                    ForEach(0...15, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 45)

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

                Picker("Soviet CAPs", selection: $sovietCAP) {
                    ForEach(0...15, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 45)

                ZStack {
                    StarShape()
                        .fill(Color.red)
                }
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 15)
            }
        }
    }
}
