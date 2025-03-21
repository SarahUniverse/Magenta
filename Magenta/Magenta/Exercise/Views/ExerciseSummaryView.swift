//
//  ExerciseSummary.swift
//  Magenta
//
//  Created by Sarah Clark on 12/11/24.
//

import SwiftUI

struct ExerciseSummaryView: View {
    // @State private var exerciseViewModel: ExerciseViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("EXERCISE")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "figure.run")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
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
    ExerciseSummaryView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    ExerciseSummaryView()
        .preferredColorScheme(.dark)
}
