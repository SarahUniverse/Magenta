//
//  NutritionSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 12/11/24.
//

import SwiftUI

struct NutritionSummaryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("NUTRITION")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "fork.knife")
                    .foregroundStyle(.green)
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
    NutritionSummaryView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    NutritionSummaryView()
        .preferredColorScheme(.dark)
}
