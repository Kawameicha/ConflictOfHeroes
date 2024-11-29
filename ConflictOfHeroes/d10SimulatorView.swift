//
//  d10SimulatorView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 27.11.24.
//

import SwiftUI

struct d10SimulatorView: View {
    @State private var dieValue = 1
    @State private var isRolling = false
    let weightedFaces = [1, 1, 2, 3, 3, 4, 5, 5, 6, 7]

    var body: some View {
        VStack(spacing: 20) {
            d10View(value: dieValue, isRolling: isRolling)

//            Text("Result: \(dieValue)")
//                .font(.title)
//                .bold()

            Button(action: rollDie) {
                Text("Roll Die")
                    .padding()
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
    }

    private func rollDie() {
        isRolling = true
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            for _ in 1...6 {
                dieValue = weightedRandom()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dieValue = weightedRandom()
            isRolling = false
        }
    }

    private func weightedRandom() -> Int {
        weightedFaces.randomElement()!
    }
}

#Preview {
    d10SimulatorView()
}
