//
//  UnitSymbol.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 19.11.24.
//

import SwiftUI

struct UnitSymbol: View {
    let unit: Unit

    var body: some View {
        ZStack {
            switch unit.army {
            case .german:
                CrossShape(widthFactor: 0.3)
                    .foregroundColor(.black)

                CrossShape(widthFactor: 0.25)
                    .foregroundColor(.white)

                CrossShape(widthFactor: 0.2)
                    .foregroundColor(.black)
            case .soviet:
                StarShape()
                    .fill(Color.red)
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct CrossShape: Shape {
    var widthFactor: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = min(rect.width, rect.height) * widthFactor

        let verticalRect = CGRect(
            x: rect.midX - width / 2,
            y: rect.minY,
            width: width,
            height: rect.height
        )
        path.addRect(verticalRect)

        let horizontalRect = CGRect(
            x: rect.minX,
            y: rect.midY - width / 2,
            width: rect.width,
            height: width
        )
        path.addRect(horizontalRect)

        return path
    }
}

struct StarShape: Shape {
    let corners: Int = 5
    let smoothness: Double = 0.5

    func path(in rect: CGRect) -> Path {
        guard corners >= 2 else { return Path() }
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        var currentAngle = -CGFloat.pi / 2
        let angleAdjustment = .pi * 2 / Double(corners * 2)
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness
        var path = Path()
        path.move(
            to: CGPoint(
                x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)
            ))
        var bottomEdge: Double = 0

        for corner in 0..<corners * 2 {
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: Double

            if corner.isMultiple(of: 2) {
                bottom = center.y * sinAngle
                path.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
            } else {
                bottom = innerY * sinAngle
                path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
            }
            if bottom > bottomEdge {
                bottomEdge = bottom
            }
            currentAngle += angleAdjustment
        }

        let unusedSpace = (rect.height / 2 - bottomEdge) / 2
        let transform = CGAffineTransform(
            translationX: center.x, y: center.y + unusedSpace)

        return path.applying(transform)
    }
}
