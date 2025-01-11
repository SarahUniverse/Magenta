//
//  PaintRevealModifier.swift
//  Magenta
//
//  Created by Sarah Clark on 1/11/25.
//

import SwiftUI

// Custom Modifier to Reveal Gradient
struct PaintRevealModifier: AnimatableModifier {
    var isRevealed: Bool

    var animatableData: CGFloat {
        get { isRevealed ? 1.0 : 0.0 }
        set { }
    }

    func body(content: Content) -> some View {
        content
            .mask(
                GeometryReader { geometry in
                    Rectangle()
                        .frame(width: geometry.size.width * (isRevealed ? 1.0 : 0.0))
                }
            )
    }
}
