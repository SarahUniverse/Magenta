//
//  TabbedContentView.swift
//  Magenta
//
//  Created by Sarah Clark on 4/10/25.
//

import SwiftUI

struct TabbedContentView: View {
    @Binding var selectedTab: Int

    let features = [
        (icon: "paintpalette", title: "Art Therapy", description: "Interactive tools for creative expression to support mental health. Guided art prompts, track emotional impact of art sessions."),
        (icon: "pencil.and.scribble", title: "Journal", description: "Private journaling with suggestions from Apple's Journaling Suggestions framework. Daily entries with prompts, mood tagging, search and filter entries."),
        (icon: "figure.run", title: "Exercise", description: "Tools to track and encourage physical activity for mental well-being. Activity tracking via HealthKit, set exercise goals, guided workout routines, reminders for movement breaks, log mental health benefits of exercise."),
        (icon: "moon.zzz.fill", title: "Sleep", description: "Features to monitor and improve sleep patterns. Sleep tracking via HealthKit, bedtime reminders, sleep quality analysis, guided wind-down routines, sleep goal setting and progress tracking."),
        (icon: "theatermasks.fill", title: "Mood Tracking", description: "Track daily moods and identify patterns over time. Daily mood logging with emoji selection, 7-day bar chart summary, today’s mood circle indicator with month/date navigation."),
        (icon: "fork.knife", title: "Nutrition", description: "Guidance on nutrition to support mental health. Log meals and water intake, nutritional tips for mental well-being, mood-food correlation tracking, personalized meal suggestions, integration with HealthKit."),
        (icon: "books.vertical", title: "Books that Help Me", description: "Curated digital bookshelf for mental health and personal growth. Track books, organize by status (Want to Read, Currently Reading, Finished Reading), add notes and reflections, search for recommended books."),
        (icon: "music.note.list", title: "Mental Health Playlists", description: "Curate playlists using Apple's MusicKit framework. Create, edit, and delete playlists; search and add songs; view playlist details; sort playlists by creation date; swipe-to-delete playlists."),
        (icon: "text.quote", title: "Helpful Quotes", description: "Inspirational quotes to uplift and motivate users. Curated collection, add new quotes, manage favorites, visually engaging summary with animations and customization."),
        (icon: "brain.head.profile", title: "Therapist Search", description: "Locate nearby mental health professionals via FindTreatment API. Search by location, filter by specialty and insurance, view profiles, save favorites, direct contact options."),
        (icon: "figure.mind.and.body", title: "Meditations", description: "Library of guided meditations for relaxation and stress reduction. Filter by duration and theme (e.g., stress, sleep), track meditation history, set reminders, save favorite sessions."),
        (icon: "calendar.badge.clock", title: "Cycle Tracking", description: "Period cycle tracking for females using HealthKit, linked to mental health. Track cycles, log symptoms and moods, analyze cycle impact on mental health, receive wellness tips.")
    ]

    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(features.indices, id: \.self) { index in
                FeatureView(
                    icon: features[index].icon,
                    title: features[index].title,
                    description: features[index].description
                )
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .frame(height: 150)
        .padding(.horizontal)
    }

}

// MARK: - Previews
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
