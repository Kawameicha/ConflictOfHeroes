//
//  UnitStatsView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 24.11.24.
//

import SwiftUI

struct UnitStatsView: View {
    var unit: Unit

    var body: some View {
        ZStack {
            VStack {
                if let cost = unit.stats.costAttack, unit.stats.turretUnit == true {
                    Text("\(cost)")
                        .background(Circle().fill(Color.white))
                } else if let cost = unit.stats.costAttack, let indirect = unit.stats.indirectAttack {
                    Text("\(cost)")
                    Text("(\(indirect))")
                } else if let cost = unit.stats.costAttack {
                    Text("\(cost)")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)


            VStack {
                if let cost = unit.stats.costMove {
                    Text("\(cost)")
                        .foregroundStyle(unit.type == .foot ? .red : .blue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

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
                        .foregroundStyle(unit.type == .foot ? .red : .blue)
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
    let unit = Unit(name: "Rifles '41", type: .foot, army: .german, statsDictionary: statsDictionary)
    UnitStatsView(unit: unit)
}
