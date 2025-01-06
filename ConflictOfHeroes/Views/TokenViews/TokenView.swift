//
//  TokenView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 05.01.25.
//

import SwiftUI

struct TokenView: View {
    var unit: Unit

    var body: some View {
        ZStack {
            if let imageName = backgroundImageName(for: unit) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                    .padding(-4)
            }

            tokenContent(unit: unit)

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
                    .fill(Color("\(unit.army)"))
            }
        )
    }

    private func backgroundImageName(for unit: Unit) -> String? {
        switch unit.name {
        case "Artillery", "Barbed Wire", "Bunkers", "Hasty Defenses", "Immobilized", "Mines", "Road Blocks", "Trenches":
            return unit.name
        case "Smoke":
            return unit.exhausted ? "heavy_smoke" : "light_smoke"
        default:
            return nil
        }
    }

    @ViewBuilder
    private func tokenContent(unit: Unit) -> some View {
        switch unit.name {
        case "Barbed Wire":
            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 2) {
                    HStack(spacing: 0) {
                        Image(systemName: "figure.walk")
                            .foregroundColor(.foot)

                        Text("+")

                        Image(systemName: "die.face.6.fill")
                    }

                    Image(systemName: "circle.slash")
                        .scaleEffect(x: -1, y: 1)
                        .foregroundColor(.wheeled)
                }

                TrackedBonusMove(showSlash: true)
                    .padding(.trailing, 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            Text("15")
                .foregroundColor(.foot)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        case "Bunkers":
            ZStack {
                GreenPolygon()
                    .fill(Color.red)

                WhitePolygon()
                    .fill(Color.white)
            }
            .aspectRatio(1.0, contentMode: .fit)
            .scaleEffect(0.5, anchor: .top)
            .padding(-4)

            VStack(spacing: 2) {
                ShieldIconView(bonus: 3)

                ShieldIconView(bonus: 5)

                Text("16")
                    .foregroundColor(.foot)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        case "Control":
            Text("\(unit.name)")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            UnitSymbol(unit: unit)
                .scaleEffect(0.5, anchor: .center)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        case "Hasty Defenses":
            VStack(spacing: 2) {
                ShieldIconView(bonus: 1)

                Text("13")
                    .foregroundColor(.foot)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        case "Immobilized":
            HStack(spacing: 2) {
                Image(systemName: "circle.slash")
                    .scaleEffect(x: -1, y: 1)
                    .foregroundColor(.tracked)

                Image(systemName: "circle.slash")
                    .scaleEffect(x: -1, y: 1)
                    .foregroundColor(.wheeled)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            VStack {
                Text("-1")
                    .foregroundStyle(.white)
                    .background(Color(.tracked))

                Text("-1")
                    .foregroundStyle(Color(.tracked))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        case "Mines":
            Text("\(unit.name)")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            VStack(spacing: 2) {
                TrackedBonusMove(showSlash: true)

                WheeledBonusMove(showSlash: true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            HStack(spacing: 0) {
                Image(systemName: "flame.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.yellow, .red)

                Text("\u{2265}8")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

            Text("15")
                .foregroundColor(.foot)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        case "Road Blocks":
            VStack(spacing: 2) {
                TrackedBonusMove(showSlash: true)

                Image(systemName: "circle.slash")
                    .scaleEffect(x: -1, y: 1)
                    .foregroundColor(.wheeled)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            Text("15")
                .foregroundColor(.foot)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        case "Smoke":
            if unit.exhausted {
                VStack(spacing: 2) {
                    TrackedBonusMove(showSlash: true)

                    WheeledBonusMove(showSlash: true)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                Image(systemName: "eye.slash")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                ShieldIconView(bonus: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            } else {
                ShieldIconView(bonus: 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        case "Trenches":
            VStack(spacing: 2) {
                TrackedBonusMove(showSlash: true)

                Image(systemName: "circle.slash")
                    .scaleEffect(x: -1, y: 1)
                    .foregroundColor(.wheeled)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            VStack(spacing: 2) {
                ShieldIconView(bonus: 2)

                Text("16")
                    .foregroundColor(.foot)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        default:
            EmptyView()
        }
    }
}

struct ShieldIconView: View {
    var bonus: Int

    var body: some View {
        ZStack {
            Image(systemName: "shield")
                .font(.system(size: 12))

            Image(systemName: "shield.fill")
                .foregroundColor(.white)

            Text("+\(bonus)")
                .font(.system(size: 6))
        }
    }
}
