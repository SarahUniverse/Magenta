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
            Tab("Summary", systemImage: "heart.fill") { SummaryView() }
            Tab("Mood", systemImage: "face.smiling.inverse") { MoodView() }
            Tab("Meditate", systemImage: "figure.mind.and.body") { MeditateView() }
            Tab("Exercise", systemImage: "figure.run") { ExerciseView() }
            Tab("More", systemImage: "line.3.horizontal") { MoreView() }
        }
        .tint(.mediumBlue)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    // Create a temporary Core Data container for preview
    let previewContainer = NSPersistentContainer(name: "Model") // Make sure this matches your .xcdatamodeld file name
    previewContainer.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    // Create a sample UserEntity for preview
    let context = previewContainer.viewContext
    let sampleUser = UserEntity(context: context)
    sampleUser.id = UUID()
    sampleUser.username = "Sarah"

    return MainView(userEntity: sampleUser)
}
