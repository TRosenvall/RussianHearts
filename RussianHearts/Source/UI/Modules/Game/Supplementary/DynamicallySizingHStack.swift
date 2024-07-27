//
//  DynamicallySizingHStack.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 7/3/24.
//

import SwiftUI

struct DynamicallySizingHStack<Content: View>: View {
    var itemCount: Int
    var itemWidth: CGFloat
    var content: () -> Content
    
    init(itemCount: Int, itemWidth: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.itemCount = itemCount
        self.itemWidth = itemWidth
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            setupHStack(geometry)
        }
    }

    func setupHStack(_ geometry: GeometryProxy) -> some View {
        let totalWidth = geometry.size.width
        let spacing: CGFloat

        if itemCount > 1 {
            let totalItemWidth = itemWidth * CGFloat(itemCount)
            let maxSpacing = (totalWidth - totalItemWidth) / CGFloat(itemCount - 1)
            spacing = max(0, maxSpacing)
        } else {
            spacing = 0
        }

        return HStack(spacing: spacing) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
