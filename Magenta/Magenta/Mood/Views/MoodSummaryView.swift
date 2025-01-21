//
//  MoodSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct MoodSummaryView: View {
    // @StateObject private var moodSummaryViewModel: MoodSummaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("MOOD")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "theatermasks.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .blue],
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

#Preview ("Light Mode") {
    MoodSummaryView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    MoodSummaryView()
        .preferredColorScheme(.dark)
}
