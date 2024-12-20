//
//  d10View.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 27.11.24.
//

import SwiftUI

struct d10View: View {
    let value: Int
    let isRolling: Bool

    var body: some View {
        ZStack {
            Image("d10")
                .resizable()
                .scaledToFit()
                .colorInvert()
                .frame(width: 75, height: 75)

            Text("\(value)")
                .font(.largeTitle)
                .bold()
                .frame(width: 50, height: 50)
                .offset(y: -10)
        }
        .offset(x: isRolling ? CGFloat.random(in: -10...10) : 0)
        .animation(.easeInOut(duration: 0.1).repeatCount(6, autoreverses: true), value: isRolling)
    }
}

#Preview {
    d10View(value: 1, isRolling: false)
}
