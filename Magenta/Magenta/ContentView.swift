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
        // Initialize ContentViewModel with viewContext
        _contentViewModel = StateObject(wrappedValue: ContentViewModel(viewContext: viewContext))
    }

    public var body: some View {
        Group {
            if let currentUser = contentViewModel.getCurrentUser() {
                if contentViewModel.isUserLoggedIn() {
                    MainView(userEntity: currentUser)
                } else {
                    LoginView(viewContext: viewContext)
                }
            } else {
                SignUpView(viewContext: viewContext)
            }
        }
    }
}

#Preview {
    // Create a preview container
    let container = NSPersistentContainer(name: "Model") // Make sure this matches your .xcdatamodeld file name
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    return ContentView(viewContext: container.viewContext)
        .environment(\.managedObjectContext, container.viewContext)
}
