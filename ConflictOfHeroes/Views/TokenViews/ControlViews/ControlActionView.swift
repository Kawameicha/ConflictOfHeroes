//
//  ControlActionView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 29.12.24.
//

import SwiftUI

struct ControlActionView: View {
    var unit: Unit

    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                unit.army = (unit.army == .german) ? .soviet : .german
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
    let unit = Unit(name: "Control", army: .german, statsDictionary: statsDictionary)
    ControlActionView(unit: unit)
}
