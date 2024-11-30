//
//  HexagonGridView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//


import SwiftUI

struct HexagonGridView: View {
    @State var cells: [HexagonCell]
    let mapName: String
    let onHexagonSelected: (HexagonCell) -> Void

    init(cells: [HexagonCell], mapName: String, onHexagonSelected: @escaping (HexagonCell) -> Void) {
        self._cells = State(initialValue: cells)
        self.mapName = mapName
        self.onHexagonSelected = onHexagonSelected
    }

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack {
                Image(mapName)
                    .resizable()
                    .scaledToFit()

                HexagonGrid(cells) { cell in
                    HexagonView(
                        cell: cell,
                        onUnitMoved: { unit, targetCell in
                            moveUnit(unit, to: targetCell)
                        }
                    )
                    .onTapGesture {
                        onHexagonSelected(cell)
                    }
                }
            }
            .frame(width: 2965 / 2, height: 2300 / 2)
        }
    }

    private func moveUnit(_ unit: Unit, to targetCell: HexagonCell) {
        guard let sourceIndex = cells.firstIndex(where: { $0.units.contains(unit) }),
              let targetIndex = cells.firstIndex(where: { $0.id == targetCell.id }) else { return }

        cells[sourceIndex].units.removeAll { $0 == unit }
        cells[targetIndex].units.append(unit)
    }
}

//#Preview {
//    HexagonGridView(cells: hexagonGridGenerator(), mapName: "AtB_Planning_Map_1_Plains")
//}
