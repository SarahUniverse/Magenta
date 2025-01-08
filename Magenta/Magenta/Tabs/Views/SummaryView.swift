//
//  SummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct SummaryView: View {
    @StateObject private var viewModel = SummaryViewModel()
    @Environment(\.colorScheme) var colorScheme

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.lightPurple,
            Color.darkPurple,
            Color.darkBlue,
            Color.black,
            Color.black,
            Color.black,
            Color.black,
            Color.black
        ]),
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )

    // MARK: - Main View Code
    var body: some View {
        NavigationView {
                ZStack {
                    backgroundGradient
                        .edgesIgnoringSafeArea(.all)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ExerciseSummary()
                            SleepSummaryView()
                            NutritionSummaryView()
                            MeditationSummaryView()
                        }
                        .padding()
                    }
                    .navigationBarTitle("Summary")
                    .navigationBarItems(trailing: Image(systemName: "person.circle"))
                    .foregroundStyle(iconColor())
                }
            }
        }

    // MARK: - Private functions
    private func iconColor() -> Color {
        colorScheme == .dark ? .white : .black
    }
}

// MARK: - Previews
#Preview ("Light Mode") {
    SummaryView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    SummaryView()
        .preferredColorScheme(.dark)
}
