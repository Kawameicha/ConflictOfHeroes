//
//  UnitFacingView.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 19.11.24.
//

import SwiftUI

struct UnitFacingView: View {
    let unit: Unit

    var body: some View {
        ZStack {
            GreenPolygon()
                .fill(Color.front)

            WhitePolygon()
                .fill(Color.white)
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct GreenPolygon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let points: [CGPoint] = [
            CGPoint(x: 5, y: 1),
            CGPoint(x: 1.5, y: 0),
            CGPoint(x: -1.5, y: 0),
            CGPoint(x: -5, y: 1)
        ]

        let mappedPoints = points.map { point in
            CGPoint(
                x: rect.midX + point.x * rect.width / 6,
                y: rect.minY + (1 - point.y) * rect.height / 4
            )
        }

        path.move(to: mappedPoints[0])
        for point in mappedPoints.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()

        return path
    }
}

struct WhitePolygon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let points: [CGPoint] = [
            CGPoint(x: 1.5, y: 0.25),
            CGPoint(x: 1.5, y: 0),
            CGPoint(x: -1.5, y: 0),
            CGPoint(x: -1.5, y: 0.25),
            CGPoint(x: 0, y: 0.4)
        ]

        let mappedPoints = points.map { point in
            CGPoint(
                x: rect.midX + point.x * rect.width / 6,
                y: rect.minY + (1 - point.y) * rect.height / 4
            )
        }

        path.move(to: mappedPoints[0])
        for point in mappedPoints.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()

        return path
    }
}
