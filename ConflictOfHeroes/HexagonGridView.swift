//
//  HexagonGridView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//


import SwiftUI

struct HexagonGridView: View {
    @State private var cells: [HexagonCell]

    init(cells: [HexagonCell]) {
        self._cells = State(initialValue: cells)
    }

    var body: some View {
        ZStack {
            Image("AtB_Planning_Map_1_Plains")
                .resizable()
                .scaledToFit()

            HexagonGrid(cells) { cell in
                HexagonView(
                    cell: cell,
                    onUnitMoved: { unit, targetCell in
                        moveUnit(unit, to: targetCell)
                    }
                )
            }
        }
    }

    private func moveUnit(_ unit: Unit, to targetCell: HexagonCell) {
        guard let sourceIndex = cells.firstIndex(where: { $0.units.contains(unit) }),
              let targetIndex = cells.firstIndex(where: { $0.id == targetCell.id }) else { return }

        cells[sourceIndex].units.removeAll { $0 == unit }

        cells[targetIndex].units.append(unit)
    }
}

#Preview {
    HexagonGridView(cells: hexagonGridGenerator())
}
