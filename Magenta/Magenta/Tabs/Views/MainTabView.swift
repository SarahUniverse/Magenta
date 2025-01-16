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
    @StateObject private var discoverViewModel: DiscoverViewModel
    @StateObject private var accountViewModel: AccountViewModel
    let userModel: UserModel
    private let viewContext: NSManagedObjectContext
    @Environment(\.colorScheme) var colorScheme

    init(viewContext: NSManagedObjectContext, userModel: UserModel, discoverViewModel: DiscoverViewModel) {
        self.userModel = userModel
        self.viewContext = viewContext
        _mainViewModel = StateObject(wrappedValue: MainTabViewModel(viewContext: viewContext, userModel: userModel))
        _discoverViewModel = StateObject(wrappedValue: discoverViewModel)
        _accountViewModel = StateObject(wrappedValue: AccountViewModel(viewContext: viewContext))
    }

    var body: some View {
        TabView {
            SummaryView(viewContext: viewContext)
                .tabItem {
                    Label("Summary", systemImage: "heart.fill")
                }

            DiscoverView(viewContext: viewContext)
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }

            AccountView(viewContext: viewContext)
                .tabItem {
                    Label("Account", systemImage: "person.fill")
                }
        }
        .tint(.darkPurple)
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
    let discoverViewModel = DiscoverViewModel(viewContext: context, colorScheme: .light)

    return MainTabView(viewContext: context, userModel: sampleUserModel, discoverViewModel: discoverViewModel)
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
    let discoverViewModel = DiscoverViewModel(viewContext: context, colorScheme: .dark)

    return MainTabView(viewContext: context, userModel: sampleUserModel, discoverViewModel: discoverViewModel)
        .preferredColorScheme(.dark)
}
