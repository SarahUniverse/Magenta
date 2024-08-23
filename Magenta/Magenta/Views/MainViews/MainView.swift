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
                Tab("Summary", systemImage: "heart.fill") { SummaryView() }
                Tab("Mood", systemImage: "face.smiling.inverse") { MoodView() }
                Tab("Meditate", systemImage: "figure.mind.and.body") { MeditateView() }
                Tab("Exercise", systemImage: "figure.run") { ExerciseView() }
                Tab("More", systemImage: "line.3.horizontal") { MoreView() }
            }
            .navigationBarBackButtonHidden(true)
        } else {
            // TODO: Remove when iOS 17 is no longer supported.
            TabView {
                SummaryView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Summary")
                }

                MoodView()
                .tabItem {
                        Image(systemName: "face.smiling.inverse")
                        Text("Mood")
                    }

                MeditateView()
                    .tabItem {
                        Image(systemName: "figure.mind.and.body")
                        Text("Meditate")
                    }

                ExerciseView()
                    .tabItem {
                        Image(systemName: "figure.run")
                        Text("Exercise")
                    }
                MoreView()
                    .tabItem {
                        Image(systemName: "line.3.horizontal")
                        Text("More")
                    }
            }
            .tabViewStyle(DefaultTabViewStyle())
            .navigationBarBackButtonHidden(true)
        }
    }

}

#Preview {
    MainView(user: User(id: "12345678", name: "Sarah", isLoggedIn: false))
}
