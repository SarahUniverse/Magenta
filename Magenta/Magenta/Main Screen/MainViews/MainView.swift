//
//  MainView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import CoreData
import SwiftUI

struct MainView: View {
    let userEntity: UserEntity

    var body: some View {
        TabView {
            SummaryView()
                .tabItem {
                    Label("Summary", systemImage: "heart.fill")
                }

            MoodView()
                .tabItem {
                    Label("Mood", systemImage: "face.smiling.inverse")
                }

            MeditateView()
                .tabItem {
                    Label("Meditate", systemImage: "figure.mind.and.body")
                }

            ExerciseView()
                .tabItem {
                    Label("Exercise", systemImage: "figure.run")
                }

            MoreView()
                .tabItem {
                    Label("More", systemImage: "line.3.horizontal")
                }
        }
        .tint(.mediumBlue)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    let previewContainer = NSPersistentContainer(name: "Model")
    previewContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    previewContainer.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    let context = previewContainer.viewContext
    let sampleUser = UserEntity(context: context)
    sampleUser.id = UUID()
    sampleUser.username = "Sarah"
    sampleUser.email = "sarah@example.com"

    return NavigationStack {
        MainView(userEntity: sampleUser)
    }
}
