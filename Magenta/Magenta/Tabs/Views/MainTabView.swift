//
//  MainView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import CoreData
import SwiftUI

struct MainTabView: View {
    @StateObject private var mainViewModel: MainTabViewModel
    let userModel: UserModel
    private let viewContext: NSManagedObjectContext
    @Environment(\.colorScheme) var colorScheme

    init(viewContext: NSManagedObjectContext, userModel: UserModel) {
        self.userModel = userModel
        self.viewContext = viewContext
        _mainViewModel = StateObject(wrappedValue: MainTabViewModel(viewContext: viewContext, userModel: userModel))
    }

    var body: some View {
        TabView {
            SummaryView(viewContext: viewContext, colorScheme: colorScheme)
                .tabItem {
                    Label("Summary", systemImage: "heart.fill")
                }

            DiscoverView(viewContext: viewContext, colorScheme: colorScheme)
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }

            AccountView(viewContext: viewContext, colorScheme: colorScheme)
                .tabItem {
                    Label("Account", systemImage: "person.fill")
                }
        }
        .navigationBarBackButtonHidden()
    }

}

// MARK: Previews
#Preview("Light Mode") {
    let previewContainer = NSPersistentContainer(name: "DataModel")
    previewContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    previewContainer.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    let context = previewContainer.viewContext
    let sampleUserModel = UserModel.userModelDataSample(viewContext: context)

    return MainTabView(viewContext: context, userModel: sampleUserModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let previewContainer = NSPersistentContainer(name: "DataModel")
    previewContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    previewContainer.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    let context = previewContainer.viewContext
    let sampleUserModel = UserModel.userModelDataSample(viewContext: context)

    return MainTabView(viewContext: context, userModel: sampleUserModel)
        .preferredColorScheme(.dark)
}
