//
//  GameUnitView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 19.12.24.
//

import SwiftUI

struct GameUnitView: View {
    let units: [Unit]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 4) {
                let groupedUnits = Dictionary(grouping: units) { $0.identifier }

                let sortedKeys = groupedUnits.keys.sorted { lhs, rhs in
                    lhs.army.rawValue < rhs.army.rawValue || (lhs.army.rawValue == rhs.army.rawValue && lhs.name < rhs.name)
                }

                ForEach(sortedKeys, id: \.self) { key in
                    if let unitsWithGroup = groupedUnits[key] {
                        ZStack(alignment: .center) {
                            switch key.name {
                            case "Control":
                                ControlTokenView(unit: unitsWithGroup[0])
                                    .draggableUnit(unitsWithGroup[0])
                            case "Smoke":
                                SmokeTokenView(unit: unitsWithGroup[0])
                                    .draggableUnit(unitsWithGroup[0])
                            default:
                                UnitTokenView(unit: unitsWithGroup[0])
                                    .draggableUnit(unitsWithGroup[0])
                            }

                            if unitsWithGroup.count > 1 {
                                HStack {
                                    Image(systemName: "\(unitsWithGroup.count).circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.white, .red)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            }
                        }
                    }
                }
            }
            .padding(4)
        }
        .frame(width: 160, height: 300)
    }
}
