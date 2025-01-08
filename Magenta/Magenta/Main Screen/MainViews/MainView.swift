//
//  MainView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import CoreData
import SwiftUI

struct MainView: View {
    @StateObject private var mainViewModel: MainViewModel
    @StateObject private var moreViewModel: MoreViewModel
    @Binding var navigationPath: NavigationPath
    let userModel: UserModel

    init(viewContext: NSManagedObjectContext, userModel: UserModel, navigationPath: Binding<NavigationPath>) {
        self.userModel = userModel
        _mainViewModel = StateObject(wrappedValue: MainViewModel(viewContext: viewContext, userModel: userModel))
        _moreViewModel = StateObject(wrappedValue: MoreViewModel(viewContext: viewContext, currentUser: userModel))
        _navigationPath = navigationPath
    }

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

            MoreView(moreViewModel: moreViewModel, navigationPath: $navigationPath)
                .tabItem {
                    Label("More", systemImage: "line.3.horizontal")
                }
        }
        .tint(.darkPurple)
        .navigationBarBackButtonHidden()
    }
}

#Preview ("Light Mode") {
    let previewContainer = NSPersistentContainer(name: "DataModel")
    previewContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    previewContainer.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    let context = previewContainer.viewContext
    let sampleUserModel = UserModel.userModelDataSample(viewContext: context)

    return NavigationStack {
        MainView(viewContext: context, userModel: sampleUserModel, navigationPath: .constant(NavigationPath()))
    }
    .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let previewContainer = NSPersistentContainer(name: "DataModel")
    previewContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    previewContainer.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    let context = previewContainer.viewContext
    let sampleUserModel = UserModel.userModelDataSample(viewContext: context)

    return NavigationStack {
        MainView(viewContext: context, userModel: sampleUserModel, navigationPath: .constant(NavigationPath()))
    }
    .preferredColorScheme(.dark)
}
