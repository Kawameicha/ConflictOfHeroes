//
//  HexagonCellView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 19.12.24.
//

import SwiftUI

struct HexagonCellView: View {
    let hexagon: HexagonCell

    var body: some View {
        Section(header: Text("Hexagon Units")) {
            List(hexagon.units, id: \.self) { unit in
                UnitRow(unit: unit)
                    .draggableUnit(unit)
            }
            .padding(4)
        }
    }
}
