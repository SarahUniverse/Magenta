//
//  QuotesSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct QuotesSummaryView: View {
    // @StateObject private var quotesSummaryViewModel: QuotesSummaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("QUOTES")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "text.quote")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.gray, .yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Button("Review") { }
                        .foregroundColor(.blue)
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
    BooksSummaryView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    BooksSummaryView()
        .preferredColorScheme(.dark)
}
