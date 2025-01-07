//
//  TokenActionView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 05.01.25.
//

import SwiftUI

struct TokenActionView: View {
    var unit: Unit
    var action: () -> Void

    var body: some View {
        VStack {
            Button(action: action) {
                Image(systemName: "arrow.up.arrow.down")
            }
            .clipShape(Capsule())
        }
        .aspectRatio(5.75, contentMode: .fit)
        .scaleEffect(0.75, anchor: .center)
    }
}
