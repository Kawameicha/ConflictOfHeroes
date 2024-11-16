//
//  HexagonView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct HexagonView: View {
    @State private var hexagonIsTargeted = false
    var cell: HexagonCell
    var onUnitMoved: (Unit, HexagonCell) -> Void

    var body: some View {
        ZStack {
            Hexagon()
                .fill(Color.blue.opacity(0.2))

            ForEach(cell.units, id: \.self) { unit in
                Text(unit.name)
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Capsule().fill(Color.white))
                    .draggable(unit)
            }
        }
        .dropDestination(for: Unit.self) { items, location in
            guard let droppedUnit = items.first else { return false }

            onUnitMoved(droppedUnit, cell)
            return true
        } isTargeted: { isTargeted in
            hexagonIsTargeted = isTargeted
        }
    }
}
