//
//  UnitTokenView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 28.12.24.
//

import SwiftUI

struct UnitTokenView: View {
    var unit: Unit

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("\(unit.army) \(unit.name)")
                    .resizable()
                    .scaleEffect(0.9, anchor: .bottom)

                UnitSymbolView(unit: unit)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                UnitStatView(unit: unit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }

            HStack(spacing: 0) {
                if unit.hitMarker != nil {
                    Image(systemName: "cross.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .white)
                } else {
                    Image(systemName: "cross.circle.fill")
                        .foregroundStyle(.clear)
                }

                if unit.stressed {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .red)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.clear)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(width: 72, height: 72)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color(.darkGray).opacity(0.7))
                    .offset(x: -0.9, y: 1.1)

                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color("\(unit.army)"))
            }
        )
    }
}

/// Preview
struct UnitTokenGridView: View {
    let units: [Unit]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 12)

    var sortedUnits: [Unit] {
        units.sorted {
            return $0.stats.id < $1.stats.id
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(sortedUnits, id: \.id) { unit in
                    UnitTokenView(unit: unit)
                }
            }
            .frame(width: 960, height: .infinity)
        }
        .navigationTitle("Units")
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let units = createUnitsFromStats(statsDictionary: statsDictionary)
    UnitTokenGridView(units: units)
}
