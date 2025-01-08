//
//  GridItemView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/8/25.
//

import SwiftUI

struct GridItemView: View {
    let icon: String
    let title: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.darkPurple)
            Text(title)
                .bold()
                .font(.caption)
                .foregroundColor(textColor())
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .cornerRadius(10)
    }

    // MARK: - Private functions
    private func textColor() -> Color {
        colorScheme == .dark ? .white : .black
    }
}

// MARK: - Previews
#Preview ("Light Mode") {
    GridItemView(icon: "figure.run", title: "Exercise")
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    GridItemView(icon: "figure.run", title: "Exercise")
        .preferredColorScheme(.dark)
}
