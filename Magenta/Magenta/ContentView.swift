//
//  ContentView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

public struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var contentViewModel: ContentViewModel

    public init(viewContext: NSManagedObjectContext) {
        _contentViewModel = StateObject(wrappedValue: ContentViewModel(viewContext: viewContext))
    }

    public var body: some View {
        Group {
            if let currentUser = contentViewModel.getCurrentUser() {
                if contentViewModel.isUserLoggedIn() {
                    MainView(viewContext: viewContext, userModel: currentUser)
                } else {
                    LoginView(viewContext: viewContext)
                }
            } else {
                SignUpView(viewContext: viewContext)
            }
        }
    }
}

#Preview ("Light Mode") {
    let container = NSPersistentContainer(name: "DataModel")
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    return ContentView(viewContext: container.viewContext)
        .environment(\.managedObjectContext, container.viewContext)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let container = NSPersistentContainer(name: "DataModel")
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    return ContentView(viewContext: container.viewContext)
        .environment(\.managedObjectContext, container.viewContext)
        .preferredColorScheme(.dark)
}

