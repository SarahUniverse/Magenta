//
//  MainView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import SwiftUI

struct MainView: View {
    let user: UserModel

    var body: some View {
        TabView {
            Tab("Summary", systemImage: "heart.fill") { SummaryView() }
            Tab("Mood", systemImage: "face.smiling.inverse") { MoodView() }
            Tab("Meditate", systemImage: "figure.mind.and.body") { MeditateView() }
            Tab("Exercise", systemImage: "figure.run") { ExerciseView() }
            Tab("More", systemImage: "line.3.horizontal") { MoreView() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView(user: UserModel(id: "12345678", name: "Sarah"))
}
