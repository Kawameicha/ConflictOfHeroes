//
//  HexagonGrid.swift
//  ConflictOfHeroes
//
//  Created by Christoph Freier on 15.11.24.
//

import SwiftUI

public struct HexagonGrid<Data, ID, Content>: View
where
    Data: RandomAccessCollection, Data.Element: OffsetCoordinateProviding,
    ID: Hashable, Content: View
{
    public let data: Data
    public let id: KeyPath<Data.Element, ID>
    public let spacing: CGFloat
    public let content: (Data.Element) -> Content

    @inlinable public init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        spacing: CGFloat = .zero,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = id
        self.spacing = spacing / 2
        self.content = content
    }

    public var body: some View {
        HexagonLayout {
            ForEach(data, id: id) { element in
                content(element)
                    .clipShape(Hexagon())
                    .padding(.all, spacing)
                    .layoutValue(
                        key: OffsetCoordinateLayoutValueKey.self,
                        value: element.offsetCoordinate)
            }
        }
    }
}

extension HexagonGrid where ID == Data.Element.ID, Data.Element: Identifiable {
    @inlinable public init(
        _ data: Data,
        spacing: CGFloat = .zero,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.init(data, id: \.id, spacing: spacing, content: content)
    }
}
