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
                VStack(alignment: .center) {
                    Text(unit.name)
                        .foregroundStyle(.black)
                        .font(.system(size: 6))
                        .lineLimit(1)
                        .offset(y: 12)

//                    HStack {
//                        Text("\(unit.army.rawValue.capitalized) \(unit.type.rawValue) unit")
//                            .font(.subheadline)
//                    }

                    Image("\(unit.army) \(unit.name)" )
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .scaleEffect(0.9, anchor: .bottom)
                }

                UnitStatsView(unit: unit)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("\(unit.army)").opacity(0.7))
        )
//        .aspectRatio(2.75, contentMode: .fit)
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let unit = Unit(name: "Rifles '41", army: .german, statsDictionary: statsDictionary)
    UnitRow(unit: unit)
}
