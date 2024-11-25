//
//  UnitRow.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 24.11.24.
//

import SwiftUI

struct UnitRow: View {
    var unit: Unit

    var body: some View {
        HStack {
            UnitSymbol(unit: unit)

            ZStack {
                HStack(alignment: .center) {
                    Spacer()

                    Text(unit.name)
                        .font(.headline)

                    Spacer()
                }

                UnitStatsView(unit: unit)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("\(unit.army)").opacity(0.7))
        )
        .aspectRatio(2.75, contentMode: .fit)
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let unit = Unit(name: "Rifles '41", type: .foot, army: .german, statsDictionary: statsDictionary)
    UnitRow(unit: unit)
}
