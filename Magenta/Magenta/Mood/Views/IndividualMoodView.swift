//
//  IndividualMoodView.swift
//  Magenta
//
//  Created by Sarah Clark on 2/16/25.
//

import SwiftUI
import UIKit

struct IndividualMoodView: View {
    let mood: String
    let emoji: String
    @State private var isHovered = false
    let isSelected: Bool

    var body: some View {
        VStack {
            Text(emoji)
                .font(.system(size: 50))
                .padding(.top, 5)

            Text(mood)
                .font(.title3)
                .foregroundStyle(Color(white: 0.4745))
                .bold(true)
                .padding(.bottom, 20)

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.blue)
                    .shadow(color: .yellow, radius: 3)
                    .font(.system(size: 21))
                    .padding(.bottom, 10)
            }
        }
        .frame(width: 140, height: 140)
        .background(
            Circle()
                .fill(.ultraThinMaterial)
                .shadow(radius: isHovered ? 10 : 5)
        )
        .overlay(
            Circle()
                .stroke(
                    isSelected ?
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.7),
                            Color.blue.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    : LinearGradient(
                        colors: [
                            Color.clear,
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    IndividualMoodView(mood: "Excited", emoji: "🤩", isSelected: true)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    IndividualMoodView(mood: "Excited", emoji: "🤩", isSelected: true)
        .preferredColorScheme(.dark)
}
