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

    var body: some View {
        ZStack {
            Hexagon()
                .fill(Color.clear)

            ForEach(cell.units, id: \.self) { unit in
                UnitView(units: cell.units, unit: unit)
                    .contextMenu {
                        if !["Artillery", "Barbed Wire", "Control", "Bunkers", "Hasty Defenses", "Immobilized", "Mines", "Road Blocks", "Smoke", "Trenches"].contains(unit.name) {
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
                                } else {
                                    switch (unit.stats.frontType, unit.stats.flankType) {
                                    case let (front, flank) where front != flank:
                                        presentHitMarkerChoice { chosenType in
                                            if let marker = gameManager.hitMarkerPool.assignRandomHitMarker(ofType: chosenType) {
                                                unit.hitMarker = marker
                                            }
                                        }
                                    case let (front, _) where front == .foot:
                                        if let marker = gameManager.hitMarkerPool.assignRandomHitMarker(ofType: .soft) {
                                            unit.hitMarker = marker
                                        }
                                    case let (front, _) where front == .tracked:
                                        if let marker = gameManager.hitMarkerPool.assignRandomHitMarker(ofType: .hard) {
                                            unit.hitMarker = marker
                                        }
                                    default:
                                        print("Unhandled frontType or flankType case")
                                    }
                                }
                            }) {
                                Label(unit.hitMarker != nil ? "Rally Unit" : "Hit Marker",
                                      systemImage: unit.hitMarker == nil ? "" : "")
                            }
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

                            Button("Backup Units") {
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

            if [gameManager.viewModel.backUpUnits,
                gameManager.viewModel.killedUnits].contains(where: { $0.contains(droppedUnit) }) {
                onUnitAdded(droppedUnit, cell)
            } else {
                onUnitMoved(droppedUnit, cell)
            }

            return true
        } isTargeted: { isTargeted in
            hexagonIsTargeted = isTargeted
        }
    }

    private func presentHitMarkerChoice(completion: @escaping (HitMarkerType) -> Void) {
        let alert = NSAlert()
        alert.messageText = "Choose Hit Marker Type"
        alert.informativeText = "Assign a soft or armored hit marker."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Soft")
        alert.addButton(withTitle: "Armored")
        alert.addButton(withTitle: "Cancel")

        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            completion(.soft)
        case .alertSecondButtonReturn:
            completion(.hard)
        default:
            break
        }
    }
}
