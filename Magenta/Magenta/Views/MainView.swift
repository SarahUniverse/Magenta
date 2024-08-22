//
//  MainView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import SwiftUI

struct MainView: View {
    let user: User

    var body: some View {

        if #available(iOS 18.0, *) {
            TabView {
                Tab("Mood", systemImage: "face.smiling.inverse") { MoodView() }
                Tab("Meditate", systemImage: "figure.mind.and.body") { MeditateView() }
                Tab("Exercise", systemImage: "figure.run") { ExerciseView() }
                Tab("Nutrition", systemImage: "fork.knife") { NutritionView() }
                Tab("More", systemImage: "line.3.horizontal") { MoreView() }
            }
            .navigationBarBackButtonHidden(true)
        } else {
            // TODO: Remove when iOS 17 is no longer supported.
            TabView {
                tabContent(for: "Mood", systemImage: "house.fill")
                tabContent(for: "Meditate", systemImage: "figure.mind.and.body")
                tabContent(for: "Exercise", systemImage: "figure.run")
                tabContent(for: "Nutrition", systemImage: "fork.knife")
                tabContent(for: "Cycle", systemImage: "circle.dotted")
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private func tabContent(for text: String, systemImage: String) -> some View {
        Text(text)
    }

}

#Preview {
    MainView(user: User(id: "12345678", name: "Sarah", isLoggedIn: false))
}
