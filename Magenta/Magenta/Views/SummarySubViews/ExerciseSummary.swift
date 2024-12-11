//
//  ExerciseSummary.swift
//  Magenta
//
//  Created by Sarah Clark on 12/11/24.
//

import SwiftUI

struct ExerciseSummary: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("EXERCISE")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "figure.run")
                    .foregroundColor(.darkBlue)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Mental Health Questionnaire")
                        .font(.headline)
                        .foregroundColor(.white)
                    Divider()
                    Text("Along with regular reflection, assessing your current risk for common conditions can be an important part of caring for your mental health.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Button(action: {
                        // Action for "Take Questionnaire"
                    }) {
                        Text("Take Questionnaire")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(Color.almostBlack)
            .cornerRadius(10)
        }
    }
}

    #Preview {
        ExerciseSummary()
    }
