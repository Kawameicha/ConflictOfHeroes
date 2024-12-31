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
    let onHexagonSelected: (HexagonCell?) -> Void
    let onUnitToBackUp: (Unit, HexagonCell) -> Void
    let onUnitToKilled: (Unit, HexagonCell) -> Void
    let maps: [MapInfo]

    init(
        inGameUnits: Binding<[HexagonCell]>,
        backUpUnits: Binding<[Unit]>,
        killedUnits: Binding<[Unit]>,
        maps: [MapInfo],
        onHexagonSelected: @escaping (HexagonCell?) -> Void
    ) {
        self._inGameUnits = inGameUnits
        self._backUpUnits = backUpUnits
        self._killedUnits = killedUnits
        self.maps = maps
        self.onHexagonSelected = onHexagonSelected
        self.onUnitToBackUp = { _, _ in }
        self.onUnitToKilled = { _, _ in }
    }

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack(alignment: .center) {
                VStack(spacing: 0) {
                    ForEach(maps, id: \.name) { map in
                        Image(map.name)
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(rotationAngle(for: map.orientation))
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
                        onUnitToBackUp: { unit in
                            removeUnit(unit, from: cell, to: .backUp)
                        },
                        onUnitToKilled: { unit in
                            removeUnit(unit, from: cell, to: .killed)
                        }
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

    private func removeUnit(_ unit: Unit, from cell: HexagonCell, to targetState: UnitState) {
        guard let sourceIndex = inGameUnits.firstIndex(where: { $0.id == cell.id }) else { return }

        inGameUnits[sourceIndex].units.removeAll { $0 == unit }

        switch targetState {
        case .killed:
            killedUnits.append(unit)
        case .backUp:
            backUpUnits.append(unit)
        default:
            print("Invalid target state for removal.")
        }
    }

    private func addUnit(_ unit: Unit, to targetCell: HexagonCell) {
        guard let targetIndex = inGameUnits.firstIndex(where: { $0.id == targetCell.id }) else { return }

        if let sourceIndex = backUpUnits.firstIndex(of: unit) {
            backUpUnits.remove(at: sourceIndex)
        } else if let sourceIndex = killedUnits.firstIndex(of: unit) {
            killedUnits.remove(at: sourceIndex)
        } else {
            print("Error: Unit not found in backUpUnits or killedUnits.")
            return
        }

        inGameUnits[targetIndex].units.append(unit)
    }
}
