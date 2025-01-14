//
//  UnitStatView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 24.11.24.
//

import SwiftUI

struct UnitStatView: View {
    var unit: Unit

    var body: some View {
        ZStack {
            VStack {
                if let cost = unit.stats.costAttack, unit.stats.turretUnit == true {
                    Text("\(cost)")
                        .padding(1)
                        .background(Circle().fill(Color.white))
                } else if let cost = unit.stats.costAttack, let indirect = unit.stats.indirectAttack {
                    Text("\(cost)")
                    Text("(\(indirect))")
                } else if let cost = unit.stats.costAttack {
                    Text("\(cost)")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)


            VStack(spacing: 1) {
                if let cost = unit.stats.costToMove {
                    Text("\(cost)")
                        .foregroundColor(Color(unit.stats.type.rawValue))
                }
                if let moveBonus = unit.stats.moveBonus1 {
                    if moveBonus == .wheeled {
                        WheeledBonusMove()
                    } else if moveBonus == .tracked {
                        TrackedBonusMove()
                    }
                }
                if let moveBonus = unit.stats.moveBonus2 {
                    if moveBonus == .wheeled {
                        WheeledBonusMove()
                    } else if moveBonus == .tracked {
                        TrackedBonusMove()
                    }
                }
                if let coverBonus = unit.stats.coverBonus {
                    ZStack(alignment: .center) {
                        Image(systemName: "shield")
                            .font(.system(size: 12))

                        Image(systemName: "shield.fill")
                            .foregroundColor(.white)

                        Text("+\(coverBonus)")
                            .font(.system(size: 6))
                    }
                    .foregroundStyle(.foot)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            HStack(spacing: 0) {
                VStack {
                    if let attack = unit.stats.attackSoft {
                        Text("\(attack)")
                            .background(unit.stats.crewedUnit ?? false ? .white : .clear)
                            .foregroundStyle(.foot)
                    } else {
                        Text("-")
                            .foregroundStyle(.foot)
                    }
                    if let attack = unit.stats.attackHard {
                        Text("\(attack)")
                            .background(unit.stats.crewedType == .tracked ? .white : .clear)
                            .foregroundStyle(.tracked)
                    } else {
                        Text("-")
                            .foregroundStyle(.tracked)
                    }
                }

                VStack {
                    if unit.stats.attackSort == .flamethrower {
                        Image(systemName: "flame.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.red, .black)
                    } else if unit.stats.attackSort == .explosive {
                        Image(systemName: "flame.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.yellow, .red)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

            VStack {
                if let _ = unit.stats.openVehicle, let defense = unit.stats.defenseFlank {
                    Text("\(defense)")
                        .foregroundColor(Color(.tracked))
                        .background(.white)
                        .background{Rectangle().stroke(Color.foot)}
                } else if let defense = unit.stats.defenseFlank {
                    Text("\(defense)")
                        .foregroundStyle(.white)
                        .background(Color(unit.stats.flankType.rawValue))
                }
                if let defense = unit.stats.defenseFront {
                    Text("\(defense)")
                        .foregroundColor(Color(unit.stats.frontType.rawValue))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .padding(4)
        .font(.system(size: 9))
        .fontWeight(.bold)
        .foregroundStyle(.black)
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let unit = Unit(name: "88mm FlaK18", army: .german, statsDictionary: statsDictionary)
    UnitStatView(unit: unit)
}
