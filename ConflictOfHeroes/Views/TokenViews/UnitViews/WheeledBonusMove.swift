//
//  WheeledBonusMove.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 02.01.25.
//

import SwiftUI

struct WheeledBonusMove: View {
    var showSlash: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.wheeled)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 0.3)
                )
                .frame(width: 7, height: 7)

            Circle()
                .fill(Color.white)
                .frame(width: 1, height: 1)

            if showSlash {
                Path { path in
                    path.move(to: CGPoint(x: 7, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 7))
                }
                .stroke(Color.red, lineWidth: 1)
            }
        }
        .frame(width: 7, height: 7)
    }
}
