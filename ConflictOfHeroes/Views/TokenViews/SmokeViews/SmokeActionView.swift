//
//  SmokeActionView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 30.12.24.
//

import SwiftUI

struct SmokeActionView: View {
    var unit: Unit

    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                unit.exhausted.toggle()
            }) {
                Image(systemName: "arrow.up.arrow.down")
            }
            .clipShape(Capsule())
        }
        .aspectRatio(5.75, contentMode: .fit)
        .scaleEffect(0.75, anchor: .center)
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let unit = Unit(name: "Smoke", army: .german, statsDictionary: statsDictionary)
    SmokeActionView(unit: unit)
}
