//
//  ReserveUnitsView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 19.12.24.
//

import SwiftUI

struct ReserveUnitsView: View {
    let reserveUnits: [Unit]

    var body: some View {
        Section(header: Text("Reserve Units")) {
            List(reserveUnits, id: \.self) { unit in
                UnitRow(unit: unit)
                    .draggable(unit) {
                        Text(unit.name)
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Capsule().fill(Color.white))
                    }
            }
        }
        .frame(width: 190, height: 300)
    }
}
