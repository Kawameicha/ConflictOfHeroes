//
//  WheeledBonusMove.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 02.01.25.
//

import SwiftUI

struct WheeledBonusMove: View {
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
        }
    }
}

struct GreenCircleWithDotView_Previews: PreviewProvider {
    static var previews: some View {
        WheeledBonusMove()
    }
}
