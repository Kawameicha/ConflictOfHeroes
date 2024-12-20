//
//  HexagonGridView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//


import SwiftUI

struct HexagonGridView: View {
    @Binding var cells: [HexagonCell]
    @Binding var reserveUnits: [Unit]
    @Binding var removedUnits: [Unit]
    let maps: [String]
    let onHexagonSelected: (HexagonCell?) -> Void
    let onUnitRemoved: (Unit, HexagonCell) -> Void

    init(
        cells: Binding<[HexagonCell]>,
        reserveUnits: Binding<[Unit]>,
        removedUnits: Binding<[Unit]>,
        maps: [String],
        onHexagonSelected: @escaping (HexagonCell?) -> Void
    ) {
        self._cells = cells
        self._reserveUnits = reserveUnits
        self._removedUnits = removedUnits
        self.maps = maps
        self.onHexagonSelected = onHexagonSelected
        self.onUnitRemoved = { _, _ in }
    }

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack(alignment: .center) {
                VStack(spacing: 0) {
                    if let firstMap = maps.first {
                        Image(firstMap)
                            .resizable()
                            .scaledToFit()
                    }
                    if maps.count > 1 {
                        Image(maps[1])
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 2965 / 2, height: CGFloat((2300 * maps.count)) / 2)

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
                .padding(.horizontal, 24)
                .offset(x: 2)
            }
            .frame(width: 2965 / 2, height: CGFloat((2300 * maps.count)) / 2)
            .onTapGesture {
                onHexagonSelected(nil)
            }
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
