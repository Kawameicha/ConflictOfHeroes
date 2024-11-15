//
//  Unit.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI
import UniformTypeIdentifiers

struct Unit: Identifiable, Hashable, Transferable, Codable {
    var id = UUID()
    var name: String
    
    static var unitType = UTType(exportedAs: "com.example.unit")
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Unit.self, contentType: unitType)
    }
}
