//
//  ArtTherapySummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct ArtTherapySummaryView: View {
    // @StateObject private var artTherapySummaryViewModel: ArtTherapySummaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ART THERAPY")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "paintpalette")
                    .symbolRenderingMode(.multicolor)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                        .font(.subheadline)
                        .foregroundStyle(.white)

                    Button("Review") { }
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            .background(Color.almostBlack)
            .cornerRadius(10)
        }
    }
}

// MARK: - Previews
#Preview ("Light Mode") {
    ArtTherapySummaryView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    ArtTherapySummaryView()
        .preferredColorScheme(.dark)
}
