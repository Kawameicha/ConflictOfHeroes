//
//  d6SimulatorView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 23.11.24.
//

import SwiftUI

struct d6SimulatorView: View {
    @State private var die1 = 1
    @State private var die2 = 1
    @State private var isRolling = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                d6View(value: die1, isRolling: isRolling)
                d6View(value: die2, isRolling: isRolling)
            }
            
            Button(action: rollDice) {
                Text("Roll Dice")
                    .padding()
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
    
    private func rollDice() {
        isRolling = true
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            for _ in 1...6 {
                die1 = Int.random(in: 1...6)
                die2 = Int.random(in: 1...6)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            die1 = Int.random(in: 1...6)
            die2 = Int.random(in: 1...6)
            isRolling = false
        }
    }
}

#Preview {
    d6SimulatorView()
}
