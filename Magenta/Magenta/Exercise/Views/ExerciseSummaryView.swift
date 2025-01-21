//
//  ExerciseSummary.swift
//  Magenta
//
//  Created by Sarah Clark on 12/11/24.
//

import SwiftUI

struct ExerciseSummaryView: View {
    // @StateObject private var exerciseSummaryViewModel: ExerciseSummaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("EXERCISE")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)

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
    ExerciseSummaryView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    ExerciseSummaryView()
        .preferredColorScheme(.dark)
}
