//
//  DraggableModifier.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 29.12.24.
//

import SwiftUI

struct DraggableModifier: ViewModifier {
    let unit: Unit

    func body(content: Content) -> some View {
        content.draggable(unit) {
            switch unit.name {
            case "Artillery", "Barbed Wire", "Bunkers", "Control", "Hasty Defenses", "Immobilized", "Mines", "Road Blocks", "Smoke", "Trenches":
                OtherTokenView(unit: unit)
            default:
                UnitTokenView(unit: unit)
            }
        }
    }
}

extension View {
    func draggableUnit(_ unit: Unit) -> some View {
        self.modifier(DraggableModifier(unit: unit))
    }
}
