//
//  HexagonView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct HexagonView: View {
    @EnvironmentObject var gameManager: GameManager
    @State var hexagonIsTargeted = false
    var cell: HexagonCell
    var onUnitMoved: (Unit, HexagonCell) -> Void
    var onUnitAdded: (Unit, HexagonCell) -> Void
    var onUnitToBackUp: (Unit) -> Void
    var onUnitToKilled: (Unit) -> Void
    var BackUpUnits: [Unit]
    var KilledUnits: [Unit]

    var body: some View {
        ZStack {
            Hexagon()
                .fill(Color.clear)

            ForEach(cell.units, id: \.self) { unit in
                UnitView(units: cell.units, unit: unit)
                    .contextMenu {
                        Button(action: {
                            unit.stressed.toggle()
                        }) {
                            Label(unit.stressed ? "Relax Unit" : "Stress Unit",
                                  systemImage: unit.stressed ? "" : "")
                        }

                        Button(action: {
                            if let hitMarker = unit.hitMarker {
                                gameManager.hitMarkerPool.returnHitMarker(hitMarker)
                                unit.hitMarker = nil
                            } else if let marker = gameManager.hitMarkerPool.assignRandomSoftHitMarker() {
                                unit.hitMarker = marker
                            }
                        }) {
                            Label(unit.hitMarker != nil ? "Rally Unit" : "Hit Marker",
                                  systemImage: unit.hitMarker == nil ? "" : "")
                        }

                        Menu("Assign to") {
                            Button("Killed Units") {
                                onUnitToKilled(unit)
                                unit.stressed = false
                                if let hitMarker = unit.hitMarker {
                                    gameManager.hitMarkerPool.returnHitMarker(hitMarker)
                                    unit.hitMarker = nil
                                }
                            }

                            Button("Reinforcements") {
                                onUnitToBackUp(unit)
                                unit.stressed = false
                                if let hitMarker = unit.hitMarker {
                                    gameManager.hitMarkerPool.returnHitMarker(hitMarker)
                                    unit.hitMarker = nil
                                }
                            }
                        }

                        Divider()

                        Menu("Debug") {
                            Button("Print HitMarkerPool") {
                                print("HitMarkerPool contents: \(gameManager.hitMarkerPool.pool.map(\.name)), HitMarkerPool items: \(gameManager.hitMarkerPool.pool.count)")
                            }
                        }
                    }
                    .draggableUnit(unit)
            }
        }
        .dropDestination(for: Unit.self) { items, location in
            guard let droppedUnit = items.first else { return false }

            if BackUpUnits.contains(droppedUnit) {
                onUnitAdded(droppedUnit, cell)
            } else if KilledUnits.contains(droppedUnit) {
                onUnitAdded(droppedUnit, cell)
            } else {
                onUnitMoved(droppedUnit, cell)
            }

            return true
        } isTargeted: { isTargeted in
            hexagonIsTargeted = isTargeted
        }
    }
}
