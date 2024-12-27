//
//  HexagonGridView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//


import SwiftUI

struct HexagonGridView: View {
    @Binding var inGameUnits: [HexagonCell]
    @Binding var backUpUnits: [Unit]
    @Binding var killedUnits: [Unit]
    let maps: [String: MapsSetup]
    let onHexagonSelected: (HexagonCell?) -> Void
    let onUnitRemoved: (Unit, HexagonCell) -> Void

    init(
        cells: Binding<[HexagonCell]>,
        reserveUnits: Binding<[Unit]>,
        removedUnits: Binding<[Unit]>,
        maps: [String: MapsSetup],
        onHexagonSelected: @escaping (HexagonCell?) -> Void
    ) {
        self._inGameUnits = cells
        self._backUpUnits = reserveUnits
        self._killedUnits = removedUnits
        self.maps = maps
        self.onHexagonSelected = onHexagonSelected
        self.onUnitRemoved = { _, _ in }
    }

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack(alignment: .center) {
                VStack(spacing: 0) {
                    ForEach(Array(maps.prefix(4)), id: \.key) { mapName, orientation in
                        Image(mapName)
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(rotationAngle(for: orientation))
                    }
                }
                .frame(width: 2965 / 2, height: CGFloat((2300 * maps.count)) / 2)

                HexagonGrid(inGameUnits) { cell in
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
                        reserveUnits: backUpUnits
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

    private func rotationAngle(for orientation: MapsSetup) -> Angle {
        switch orientation {
        case .N: return .degrees(0)
        case .E: return .degrees(90)
        case .S: return .degrees(180)
        case .W: return .degrees(270)
        }
    }

    private func moveUnit(_ unit: Unit, to targetCell: HexagonCell) {
        guard let sourceIndex = inGameUnits.firstIndex(where: { $0.units.contains(unit) }),
              let targetIndex = inGameUnits.firstIndex(where: { $0.id == targetCell.id }) else { return }

        inGameUnits[sourceIndex].units.removeAll { $0 == unit }
        inGameUnits[targetIndex].units.append(unit)
    }

    private func removeUnit(_ unit: Unit, from cell: HexagonCell) {
        guard let sourceIndex = inGameUnits.firstIndex(where: { $0.id == cell.id }) else { return }

        inGameUnits[sourceIndex].units.removeAll { $0 == unit }
//        killedUnits.append(unit)
        backUpUnits.append(unit)
    }

    private func addUnit(_ unit: Unit, to targetCell: HexagonCell) {
        guard let targetIndex = inGameUnits.firstIndex(where: { $0.id == targetCell.id }),
              let sourceIndex = backUpUnits.firstIndex(of: unit) else { return }

        backUpUnits.remove(at: sourceIndex)
        inGameUnits[targetIndex].units.append(unit)
    }
}
