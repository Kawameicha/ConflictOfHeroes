//
//  HexagonGridView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//


import SwiftUI

struct HexagonGridView: View {
    @State var cells: [HexagonCell]
    @Binding var reserveUnits: [Unit]
    @Binding var removedUnits: [Unit]
    let mapName: String
    let onHexagonSelected: (HexagonCell) -> Void
    let onUnitRemoved: (Unit, HexagonCell) -> Void
    
    init(
        cells: [HexagonCell],
        reserveUnits: Binding<[Unit]>,
        removedUnits: Binding<[Unit]>,
        mapName: String,
        onHexagonSelected: @escaping (HexagonCell) -> Void
    ) {
        self._cells = State(initialValue: cells)
        self._reserveUnits = reserveUnits
        self._removedUnits = removedUnits
        self.mapName = mapName
        self.onHexagonSelected = onHexagonSelected
        self.onUnitRemoved = { _, _ in }
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
                        },
                        onUnitAdded: { unit, targetCell in
                            addUnit(unit, to: targetCell)
                        },
                        onUnitRemoved: { unit in
                            removeUnit(unit, from: cell)
                        },
                        reserveUnits: reserveUnits
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

    private func removeUnit(_ unit: Unit, from cell: HexagonCell) {
        guard let sourceIndex = cells.firstIndex(where: { $0.id == cell.id }) else { return }

        cells[sourceIndex].units.removeAll { $0 == unit }
//        removedUnits.append(unit)
        reserveUnits.append(unit)
    }

    private func addUnit(_ unit: Unit, to targetCell: HexagonCell) {
        guard let targetIndex = cells.firstIndex(where: { $0.id == targetCell.id }),
              let sourceIndex = reserveUnits.firstIndex(of: unit) else { return }

        reserveUnits.remove(at: sourceIndex)
        cells[targetIndex].units.append(unit)
    }
}

//#Preview {
//    HexagonGridView(cells: hexagonGridGenerator(), mapName: "AtB_Planning_Map_1_Plains")
//}
