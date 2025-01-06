//
//  HitTokenView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 02.12.24.
//

import SwiftUI

struct HitTokenView: View {
    var hitMarker: HitMarker

    var body: some View {
        ZStack {
            VStack {
                if let rally = hitMarker.rally {
                    Text("R\u{2265}\(rally)")
                } else if hitMarker.name == "Destroyed" {
                    Text("XX")
                } else {
                    Text("No Rally")
                }

                Spacer()

                Text("\(hitMarker.name)")

                Spacer()

                if hitMarker.rangeDisabled ?? false {
                    Text("1")
                } else {
                    Text("")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            VStack {
                if hitMarker.attackDisabled ?? false {
                    Image(systemName: "slash.circle")
                } else if let attackCost = hitMarker.attackCost {
                    if attackCost >= 0 {
                        Text("+\(attackCost)")
                    } else {
                        Text("\(attackCost)")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            VStack {
                if hitMarker.moveDisabled ?? false {
                    Image(systemName: "slash.circle")
                } else if let moveCost = hitMarker.moveCost {
                    Text("+\(moveCost)")
                        .foregroundStyle(hitMarker.type == .soft ? Color(.foot) : Color(.tracked))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            HStack(spacing: 0) {
                if hitMarker.attackDisabled ?? false {
                    Image(systemName: "slash.circle")
                } else if hitMarker.gunDamaged != nil {
                    Image(systemName: "slash.circle")
                        .foregroundStyle(hitMarker.gunDamaged == .soft ? Color(.foot) : Color(.tracked))
                } else if let attackSoft = hitMarker.attackSoft, let attackHard = hitMarker.attackHard {
                    VStack {
                        if attackSoft >= 0 {
                            Text("+\(attackSoft)")
                                .foregroundStyle(.foot)
                        } else {
                            Text("\(attackSoft)")
                                .foregroundStyle(.foot)
                        }

                        if attackHard >= 0 {
                            Text("+\(attackHard)")
                                .foregroundStyle(.tracked)
                        } else {
                            Text("\(attackHard)")
                                .foregroundStyle(.tracked)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

            VStack {
                if let defenseFlank = hitMarker.defenseFlank, let defenseFront = hitMarker.defenseFront {
                    VStack {
                        if defenseFlank >= 0 {
                            Text("+\(defenseFlank)")
                                .foregroundStyle(.white)
                                .background(hitMarker.type == .soft ? Color(.foot) : Color(.tracked))
                        } else {
                            Text("\(defenseFlank)")
                                .foregroundStyle(.white)
                                .background(hitMarker.type == .soft ? Color(.foot) : Color(.tracked))
                        }

                        if defenseFront >= 0 {
                            Text("+\(defenseFront)")
                        } else {
                            Text("\(defenseFront)")
                        }
                    }
                    .foregroundStyle(hitMarker.type == .soft ? Color(.foot) : Color(.tracked))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .padding(4)
        .font(.system(size: 9))
        .fontWeight(.bold)
        .foregroundStyle(.black)
        .frame(width: 72, height: 72)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color(.darkGray).opacity(0.7))
                    .offset(x: -0.9, y: 1.1)

                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(hitMarker.type == .soft ? Color(.hitSoft) : Color(.hitHard))
            }
        )
    }
}

/// Preview
struct HitMarkerGridView: View {
    let hitMarkers: [HitMarker]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 8)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(hitMarkers, id: \.id) { hitMarker in
                    HitTokenView(hitMarker: hitMarker)
                }
            }
            .frame(width: 640, height: .infinity)
        }
        .navigationTitle("Hit Markers")
    }
}

#Preview {
    let hitMarkers = loadFromJson(from: "HitMarkers", ofType: HitMarker.self)
    HitMarkerGridView(hitMarkers: hitMarkers)
}
