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
        HStack(spacing: 4) {
            switch unit.name {
            case "Control":
                ControlTokenView(unit: unit)
            case "Smoke":
                SmokeTokenView(unit: unit)
            default:
                UnitTokenView(unit: unit)
            }

            if let hitMarker = unit.hitMarker {
                HitTokenView(hitMarker: hitMarker)
            } else {
                EmptyView()
            }
        }
        .padding(4)
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let hitMarkers = loadFromJson(from: "HitMarkers", ofType: HitMarker.self)
    let unit = Unit(name: "Rifles '41", army: .german, hitMarker: hitMarkers.first , statsDictionary: statsDictionary)
    UnitRow(unit: unit)
}
