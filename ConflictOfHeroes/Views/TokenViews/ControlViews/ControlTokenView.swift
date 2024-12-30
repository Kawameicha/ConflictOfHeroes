//
//  ControlTokenView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 29.12.24.
//

import SwiftUI

struct ControlTokenView: View {
    var units: [Unit] = []
    var unit: Unit

    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .center) {
                Text("\(unit.name)")
                Spacer()
            }
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(.black)

            UnitSymbol(unit: unit)
                .scaleEffect(0.5, anchor: .center)
        }
        .frame(width: 75, height: 75)
        .background(
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(Color("\(unit.army)"))
        )
        .background(
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(.gray)
                .offset(x: -0.9, y: 1.1)
        )
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let unit = Unit(name: "Control", army: .german, statsDictionary: statsDictionary)
    ControlTokenView(unit: unit)
}
