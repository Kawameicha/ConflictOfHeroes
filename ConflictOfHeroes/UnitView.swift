//
//  UnitView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 17.11.24.
//

import SwiftUI

struct UnitView: View {
    var units: [Unit]
    @Bindable var unit: Unit

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if unit.type == .control {
                    ZStack(alignment: .center) {
                        UnitSymbol(unit: unit)
                            .scaleEffect(0.5, anchor: .center)

                        VStack(alignment: .center) {
                            Text("\(unit.name)")
                            Spacer()
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)

                        Button(action: {
                            unit.army = (unit.army == .german) ? .soviet : .german
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        .clipShape(Capsule())
                        .frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
                    }
                } else {
                    Image("\(unit.name)")
                        .resizable()
                        .scaleEffect(0.9, anchor: .bottom)

                    UnitSymbolsView(unit: unit)
                        .frame(width: geometry.size.width, height: geometry.size.height)

                    UnitStatsView(unit: unit)
                        .frame(width: geometry.size.width, height: geometry.size.height)

                    UnitActionsView(unit: unit)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }

                if units.count > 1 {
                    Text("\(units.count - 1)+")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Circle().fill(Color.red))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
            }
            .frame(width: 75, height: 75)
            .background(
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color("\(unit.army)"))
            )
            .rotationEffect(rotationAngle(for: unit.orientation))
        }
        .frame(width: 75, height: 75)
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

extension UnitFront {
    func next() -> UnitFront {
        switch self {
        case .N: return .NE
        case .NE: return .SE
        case .SE: return .S
        case .S: return .SW
        case .SW: return .NW
        case .NW: return .N
        }
    }

    func previous() -> UnitFront {
        switch self {
        case .N: return .NW
        case .NE: return .N
        case .SE: return .NE
        case .S: return .SE
        case .SW: return .S
        case .NW: return .SW
        }
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let unit = Unit(name: "Pioneers", type: .foot, army: .german, statsDictionary: statsDictionary)
    UnitView(units: [unit, unit], unit: unit)
}
