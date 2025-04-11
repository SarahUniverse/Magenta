//
//  TabbedContentView.swift
//  Magenta
//
//  Created by Sarah Clark on 4/10/25.
//

import SwiftUI

struct TabbedContentView: View {
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            switch selectedTab {
                case 0:
                    FeatureView(
                        icon: "moon.zzz.fill",
                        title: "Sleep Tracking",
                        description: "Log your daily sleep durations, view patterns with a 7-day bar chart, and set sleep goals."
                    )
                case 1:
                    FeatureView(
                        icon: "theatermasks.fill",
                        title: "Mood Tracking",
                        description: "Log your daily moods, view patterns with a 7-day bar chart, and understand your emotional trends."
                    )
                case 2:
                    FeatureView(
                        icon: "figure.mind.and.body",
                        title: "Meditations",
                        description: "Access guided meditations to reduce stress and improve sleep, with options to save favorites."
                    )
                case 3:
                    FeatureView(
                        icon: "pencil.and.scribble",
                        title: "Journal",
                        description: "Write daily entries with prompts from Apple’s Journaling Suggestions, tag moods, and reflect privately."
                    )
                default:
                    EmptyView()
            }
        }
        .frame(height: 150)
        .padding(.horizontal)
    }
}

#Preview("Light Mode"){
    TabbedContentView(selectedTab: .constant(0))
        .preferredColorScheme(.light)
        .background(AppGradients.backgroundGradient)
}

#Preview("Dark Mode") {
    TabbedContentView(selectedTab: .constant(0))
        .preferredColorScheme(.dark)
        .background(AppGradients.backgroundGradient)
}
