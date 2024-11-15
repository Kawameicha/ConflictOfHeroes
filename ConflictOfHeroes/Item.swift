//
//  Item.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
