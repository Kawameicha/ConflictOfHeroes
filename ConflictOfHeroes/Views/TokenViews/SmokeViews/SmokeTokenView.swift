//
//  SmokeTokenView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 29.12.24.
//

import SwiftUI

struct SmokeTokenView: View {
    var units: [Unit] = []
    var unit: Unit

    var body: some View {
        ZStack(alignment: .center) {
            if unit.army == .german {
                HStack(alignment: .center) {
                    Image(systemName: "circle.slash")
                        .foregroundColor(.wheeled)

                    Image(systemName: "rectangle.slash")
                        .foregroundColor(.tracked)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                ZStack(alignment: .center) {
                    Image(systemName: "eye.slash")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                ZStack(alignment: .center) {
                    Image(systemName: "shield")
                        .font(.system(size: 12))

                    Image(systemName: "shield.fill")
                        .foregroundColor(.white)

                    Text("+2")
                        .font(.system(size: 6))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            } else {
                ZStack(alignment: .center) {
                    Image(systemName: "shield")
                        .font(.system(size: 12))

                    Image(systemName: "shield.fill")
                        .foregroundColor(.white)

                    Text("+1")
                        .font(.system(size: 6))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
        .padding(4)
        .font(.system(size: 9))
        .fontWeight(.bold)
        .foregroundStyle(.black)
        .frame(width: 75, height: 75)
        .background(
            Image(unit.army == .german ? "heavy_smoke" : "light_smoke")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
        )
        .background(
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(.gray)
                .offset(x: -0.9, y: 1.1)
        )
    }
}

#Preview {
    let statsDictionary = loadUnitStatsFromFile()
    let unit = Unit(name: "Smoke", army: .german, statsDictionary: statsDictionary)
    SmokeTokenView(unit: unit)
}
