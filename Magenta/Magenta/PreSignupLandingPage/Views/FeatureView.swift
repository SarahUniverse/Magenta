//
//  FeatureView.swift
//  Magenta
//
//  Created by Sarah Clark on 4/10/25.
//

import SwiftUI

struct FeatureView: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)

            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            Text(description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    FeatureView (icon: "paintpalette", title: "Art Therapy", description: "Interactive tools for creative expression to support mental health. Guided art prompts, track emotional impact of art sessions.")
        .preferredColorScheme(.light)
        .background(AppGradients.backgroundGradient)
}

#Preview("Dark Mode") {
    FeatureView (icon: "paintpalette", title: "Art Therapy", description: "Interactive tools for creative expression to support mental health. Guided art prompts, track emotional impact of art sessions.")
        .preferredColorScheme(.dark)
        .background(AppGradients.backgroundGradient)
}
