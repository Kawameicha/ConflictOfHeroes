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
            LazyVStack(alignment: .leading, spacing: 8) {
                let groupedUnits = Dictionary(grouping: units) { $0.identifier }

                let tokenNames: Set<String> = ["Artillery", "Barbed Wire", "Bunkers", "Control", "Hasty Defenses", "Immobilized", "Mines", "Road Blocks", "Smoke", "Trenches"]

                let tokenIdentifiers = groupedUnits.filter { tokenNames.contains($0.key.name) }
                let unitIdentifiers = groupedUnits.filter { !tokenNames.contains($0.key.name) }

                let sortedTokenKeys = tokenIdentifiers.keys.sorted { $0.name < $1.name }
                let sortedUnitKeys = unitIdentifiers.keys.sorted { lhs, rhs in
                    lhs.army.rawValue < rhs.army.rawValue || (lhs.army.rawValue == rhs.army.rawValue && lhs.name < rhs.name)
                }

                if !sortedUnitKeys.isEmpty {
                    Section(header: Text("Units").font(.headline)) {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 6), spacing: 4) {
                            ForEach(sortedUnitKeys, id: \.self) { key in
                                if let unitsWithGroup = groupedUnits[key] {
                                    ZStack(alignment: .center) {
                                        UnitTokenView(unit: unitsWithGroup[0])
                                            .draggableUnit(unitsWithGroup[0])

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
                    }
                }

                if !sortedTokenKeys.isEmpty {
                    Section(header: Text("Tokens").font(.headline)) {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 6), spacing: 4) {
                            ForEach(sortedTokenKeys, id: \.self) { key in
                                if let unitsWithGroup = groupedUnits[key] {
                                    ZStack(alignment: .center) {
                                        TokenView(unit: unitsWithGroup[0])
                                            .draggableUnit(unitsWithGroup[0])

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
                    }
                }
            }
            .padding(4)
        }
        .frame(width: 480, height: 290)
    }
}
