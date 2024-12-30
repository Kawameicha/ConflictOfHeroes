//
//  GameUnitView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 19.12.24.
//

import SwiftUI

struct GameUnitView: View {
    let units: [Unit]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 4) {
                ForEach(units, id: \.id) { unit in
                    UnitTokenView(unit: unit)
                        .draggableUnit(unit)
                }
            }
            .padding(4)
        }
        .frame(width: 160, height: 300)
    }
}
