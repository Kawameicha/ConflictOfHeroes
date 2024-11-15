//
//  ContentView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

struct ContentView: View {
    @State private var unitsHex1: [Unit] = [Unit(name: "Rifles '41")]
    @State private var unitsHex2: [Unit] = []
    @State private var hexagonIsTargeted = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(unitsHex1) { unit in
                    Text(unit.name)
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            HStack(spacing: 40) {
                ZStack {
                    Hexagon()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 150, height: 150)

                    ForEach(unitsHex1, id: \.self) { unit in
                        Text(unit.name)
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Capsule().fill(Color.white))
                            .draggable(unit)
                    }
                }
                .dropDestination(for: Unit.self) { items, location in
                    guard let firstItem = items.first else {
                        print("No item dropped.")
                        return false
                    }

                    if let index = unitsHex2.firstIndex(of: firstItem) {
                        unitsHex2.remove(at: index)
                        unitsHex1.append(firstItem)
                        print("Dropped item: \(firstItem.name)")
                        return true
                    }
                    return false
                } isTargeted: { isTargeted in
                    hexagonIsTargeted = isTargeted
                    print("Hexagon is targeted: \(isTargeted)")
                }

                ZStack {
                    Hexagon()
                        .fill(Color.red.opacity(0.2))
                        .frame(width: 150, height: 150)

                    ForEach(unitsHex2, id: \.self) { unit in
                        Text(unit.name)
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Capsule().fill(Color.white))
                            .draggable(unit)
                    }
                }
                .dropDestination(for: Unit.self) { items, location in
                    guard let firstItem = items.first else {
                        print("No item dropped.")
                        return false
                    }

                    if let index = unitsHex1.firstIndex(of: firstItem) {
                        unitsHex1.remove(at: index)
                        unitsHex2.append(firstItem)
                        print("Dropped item: \(firstItem.name)")
                        return true
                    }
                    return false
                } isTargeted: { isTargeted in
                    hexagonIsTargeted = isTargeted
                    print("Hexagon is targeted: \(isTargeted)")
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
