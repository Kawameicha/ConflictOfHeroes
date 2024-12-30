//
//  UnitActionView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 24.11.24.
//

import SwiftUI

struct UnitActionView: View {
    var unit: Unit

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button(action: rotateCounterClockwise) {
                    Image(systemName: "arrow.counterclockwise")
                }
                .clipShape(Capsule())

                Spacer()

                Button {
                    unit.exhausted.toggle()
                } label: {
                    Image(systemName: "play")
                        .symbolVariant(unit.exhausted ? .none : .slash)
                }
                .clipShape(Capsule())

                Spacer()

                Button(action: rotateClockwise) {
                    Image(systemName: "arrow.clockwise")
                }
                .clipShape(Capsule())
            }
            .background(
                Rectangle()
                    .fill(.exhausted)
                    .opacity(unit.exhausted == true ? 0.7 : 0)
            )
        }
        .aspectRatio(5.75, contentMode: .fit)
        .scaleEffect(0.75, anchor: .center)
    }

    func rotateClockwise() {
        unit.orientation = unit.orientation.next()
    }

    func rotateCounterClockwise() {
        unit.orientation = unit.orientation.previous()
    }

    func rotationAngle(for orientation: UnitFront) -> Angle {
        switch orientation {
        case .N: return .degrees(0)
        case .NE: return .degrees(60)
        case .SE: return .degrees(120)
        case .S: return .degrees(180)
        case .SW: return .degrees(240)
        case .NW: return .degrees(300)
        }
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let unit = Unit(name: "Rifles '41", army: .german, statsDictionary: statsDictionary)
    UnitActionView(unit: unit)
}
