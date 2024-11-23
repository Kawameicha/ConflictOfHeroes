//
//  DieView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 23.11.24.
//

import SwiftUI

struct DieView: View {
    let value: Int
    let isRolling: Bool

    var body: some View {
        ZStack {
            Image("die\(value)")
                .resizable()
                .scaledToFit()
                .colorInvert()
                .frame(width: 75, height: 75)
        }
        .offset(x: isRolling ? CGFloat.random(in: -10...10) : 0)
        .animation(.easeInOut(duration: 0.1).repeatCount(6, autoreverses: true), value: isRolling)
    }
}

#Preview {
    DieView(value: 1, isRolling: false)
}
