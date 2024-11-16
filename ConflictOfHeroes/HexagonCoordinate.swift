//
//  HexagonCoordinate.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import Foundation

public struct HexagonCoordinate: Hashable, Equatable, Codable {
    public var row: Int
    public var col: Int

    public init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}

public protocol OffsetCoordinateProviding {
    var offsetCoordinate: HexagonCoordinate { get }
}
