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
                .fill(Color.clear)

            ForEach(cell.units, id: \.self) { unit in
                UnitView(units: cell.units, unit: unit)
                    .draggable(unit) {
//                        Text(unit.name)
//                            .foregroundColor(.black)
//                            .padding(8)
//                            .background(Capsule().fill(Color.white))

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
                        }
                        .frame(width: 75, height: 75)
                        .aspectRatio(1.0, contentMode: .fit)
                        .background(RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .fill(Color("\(unit.army)")))
                    }
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
