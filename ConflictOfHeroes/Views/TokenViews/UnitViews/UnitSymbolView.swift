//
//  UnitSymbolView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 24.11.24.
//

import SwiftUI

struct UnitSymbolView: View {
    var unit: Unit

    var body: some View {
        HStack(alignment: .center) {
            VStack {
                ZStack(alignment: .center) {
                    UnitFacingView(unit: unit)
                        .scaleEffect(1.2, anchor: .top)

                    Text(unit.name)
                        .foregroundStyle(.black)
                        .font(.system(size: 6))
                        .lineLimit(1)
                }

                Spacer()

                ZStack(alignment: .bottom) {
                    UnitSymbol(unit: unit)
                        .scaleEffect(0.4, anchor: .bottom)
                        .padding(4)

                    ZStack(alignment: .center) {
                        if let minRange = unit.stats.minRange, let maxRange = unit.stats.maxRange {
                            Text("\(minRange)-\(maxRange)")
                        } else if let range = unit.stats.maxRange {
                            Text("\(range)")
                        }
                    }
                    .foregroundStyle(.yellow)
                    .font(.system(size: 9))
                    .fontWeight(.bold)
                    .padding(4)
                }
            }
        }
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let unit = Unit(name: "Rifles '41", army: .german, statsDictionary: statsDictionary)
    UnitSymbolView(unit: unit)
}
