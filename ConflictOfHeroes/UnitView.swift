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
        if let unit = units.last {
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

                    GeometryReader { geometry in
                        Button(action: {
                            if unit.army == .german {
                                unit.army = .soviet
                            } else if unit.army == .soviet {
                                unit.army = .german
                            }
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
                        }
                        .clipShape(Capsule())
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                }
                .frame(width: 75, height: 75)
                .aspectRatio(1.0, contentMode: .fit)
                .background(RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color("\(unit.army)")))
            } else {
                ZStack(alignment: .center) {
                    UnitImage()
                        .resizable()
                        .scaleEffect(0.7, anchor: .bottom)

                    VStack {
                        ZStack(alignment: .top) {
                            UnitFacing(unit: unit)
                                .scaleEffect(1.7, anchor: .top)
                                .padding(-4)

                            GeometryReader { geometry in
                                HStack(alignment: .center, spacing: 0) {
                                    if let cost = unit.stats.costAttack, unit.stats.turretUnit == true {
                                        Text("\(cost)")
                                            .background(Circle().fill(Color.white))
                                            .frame(width: geometry.size.width * 0.2, alignment: .leading)
                                    } else if let cost = unit.stats.costAttack, let indirect = unit.stats.indirectAttack {
                                        VStack {
                                            Text("\(cost)")
                                            Text("(\(indirect))")
                                        }
                                        .frame(width: geometry.size.width * 0.2, alignment: .leading)
                                    } else if let cost = unit.stats.costAttack {
                                        Text("\(cost)")
                                            .frame(width: geometry.size.width * 0.2, alignment: .leading)
                                    } else {
                                        Spacer()
                                            .frame(width: geometry.size.width * 0.2)
                                    }

                                    Text(unit.name)
                                        .font(.system(size: 6))
                                        .fontWeight(.regular)
                                        .lineLimit(1)
                                        .frame(width: geometry.size.width * 0.6, alignment: .center)

                                    if let cost = unit.stats.costMove {
                                        Text("\(cost)")
                                            .foregroundStyle(unit.type == .foot ? .red : .blue)
                                            .frame(width: geometry.size.width * 0.2, alignment: .trailing)
                                    } else {
                                        Spacer()
                                            .frame(width: geometry.size.width * 0.2)
                                    }
                                }
                            }
                        }

                        Spacer()

                        GeometryReader { geometry in
                            HStack {
                                Button(action: rotateCounterClockwise) {
                                    Image(systemName: "arrow.counterclockwise")
                                        .frame(width: geometry.size.width * 0.05, alignment: .center)
                                }
                                .clipShape(Capsule())

                                Spacer()

                                Button {
                                    unit.exhausted.toggle()
                                } label: {
                                    Image(systemName: "play")
                                        .symbolVariant(unit.exhausted ? .none : .slash)
                                        .frame(width: geometry.size.width * 0.05, alignment: .center)
                                }
                                .clipShape(Capsule())

                                Spacer()

                                Button(action: rotateClockwise) {
                                    Image(systemName: "arrow.clockwise")
                                        .frame(width: geometry.size.width * 0.05, alignment: .center)
                                }
                                .clipShape(Capsule())
                            }
                            .background(
                                Rectangle()
                                    .fill(.exhausted)
                                    .opacity(unit.exhausted == true ? 0.7 : 0)
                            )
                            .padding(-4)
                        }

                        Spacer()

                        ZStack(alignment: .bottom) {
                            UnitSymbol(unit: unit)
                                .scaleEffect(0.4, anchor: .bottom)

                            HStack(alignment: .bottom) {
                                VStack {
                                    if let attack = unit.stats.attackSoft {
                                        Text("\(attack)")
                                            .background(unit.stats.crewedUnit ?? false ? .white : .clear)
                                            .foregroundStyle(.red)
                                    }
                                    if let attack = unit.stats.attackArmored {
                                        Text("\(attack)")
                                            .background(unit.stats.crewedUnit ?? false ? .white : .clear)
                                            .foregroundStyle(.blue)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                if let minRange = unit.stats.minRange, let maxRange = unit.stats.maxRange {
                                    Text("\(minRange)-\(maxRange)")
                                        .foregroundStyle(.yellow)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                } else if let range = unit.stats.maxRange {
                                    Text("\(range)")
                                        .foregroundStyle(.yellow)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }

                                VStack {
                                    if let _ = unit.stats.openVehicle, let defense = unit.stats.defenseFlank {
                                        Text("\(defense)")
                                            .background(.white)
                                            .background{Rectangle().stroke(Color.red)}
                                    } else if let defense = unit.stats.defenseFlank {
                                        Text("\(defense)")
                                            .foregroundStyle(.white)
                                            .background(unit.type == .foot ? .red : .blue)
                                    }
                                    if let defense = unit.stats.defenseFront {
                                        Text("\(defense)")
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundStyle(unit.type == .foot ? .red : .blue)
                            }
                        }
                    }
                    .padding(4)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                }
                .frame(width: 75, height: 75)
                .aspectRatio(1.0, contentMode: .fit)
                .background(RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color("\(unit.army)")))
                .rotationEffect(rotationAngle(for: unit.orientation))

                if units.count > 1 {
                    Text("\(units.count - 1)+")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Circle().fill(Color.red))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
            }
        }
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

    func UnitImage() -> Image {
        switch unit.type {
        case .foot:
            return Image("\(unit.name)")
        case .tracked:
            return Image("tracked")
        case .wheeled:
            return Image("wheeled")
        case .control:
            return Image("control")
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
    let unit = Unit(name: "Rifles '41", type: .foot, army: .german, statsDictionary: statsDictionary)
    UnitView(units: [unit], unit: unit)
}
