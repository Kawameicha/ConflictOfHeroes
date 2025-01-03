//
//  TrackedBonusMove.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 02.01.25.
//

import SwiftUI

struct TrackedBonusMove: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.tracked)
                .overlay(
                    Rectangle()
                        .stroke(Color.white, lineWidth: 0.3)
                )
                .frame(width: 8, height: 6)

            Rectangle()
                .fill(Color.white)
                .frame(width: 1, height: 1)
        }
    }
}

struct TrackedBonusMove_Previews: PreviewProvider {
    static var previews: some View {
        TrackedBonusMove()
    }
}
