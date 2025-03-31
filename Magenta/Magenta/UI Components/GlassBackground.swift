//
//  GlassBackground.swift
//  Magenta
//
//  Created by Sarah Clark on 3/31/25.
//

import SwiftUI

struct GlassBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(colorScheme == .dark ? 0.3 : 0.5),
                                .white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        .black.opacity(0.1),
                        lineWidth: 1
                    )
                    .blur(radius: 1)
                    .mask(RoundedRectangle(cornerRadius: 15).fill(.black))
            }
            .padding(.top, 10)
    }
}

#Preview("Light Mode"){
    GlassBackground()
        .padding(50) // Arbitrary number to be able to view the shadow.
        .preferredColorScheme(.light)
}

#Preview("Dark Mode"){
    GlassBackground()
        .padding(50) // Arbitrary number to be able to view the shadow.
        .preferredColorScheme(.dark)
}
