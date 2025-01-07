//
//  SummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct SummaryView: View {
    @StateObject private var viewModel = SummaryViewModel()

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
                    .foregroundStyle(Color.white)
                }
            }
        }
}

#Preview ("Light Mode") {
    SummaryView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    SummaryView()
        .preferredColorScheme(.dark)
}
