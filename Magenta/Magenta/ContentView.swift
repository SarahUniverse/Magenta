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
    @State private var contentViewModel: ContentViewModel
    @State private var loginViewModel: LoginViewModel
    @State private var biometricAuthViewModel = BiometricAuthViewModel()
    @State private var currentUser: String = ""

    public init(viewContext: NSManagedObjectContext) {
        _contentViewModel = State(wrappedValue: ContentViewModel(viewContext: viewContext))
        _loginViewModel = State(wrappedValue: LoginViewModel(viewContext: viewContext))
    }

    public var body: some View {
        Group {
            // Show LandingPageView if user has never signed up before
            if contentViewModel.hasUserSignedUp() == false {
                LandingPageView(viewContext: viewContext)
            }

            /*if contentViewModel.isUserLoggedIn() || biometricAuthViewModel.isAuthenticated {
                MainTabView(viewContext: viewContext, userModel: loginViewModel.userModel!)
                    .onAppear {
                        loginViewModel.loadSavedUser()
                        currentUser = loginViewModel.username
                    }
            } else if !contentViewModel.isUserLoggedIn() {
                LoginView(viewContext: viewContext)
            } else if !contentViewModel.isUserLoggedIn() && !biometricAuthViewModel.isAuthenticated {
                SignUpView(viewContext: viewContext)
            } else {
                WaitingOnFaceIDAuthView()
            }*/
        }
        .task {
            if contentViewModel.isUserLoggedIn() {
                await MainActor.run {
                    biometricAuthViewModel.authenticateWithFaceID()
                }
            }
        }
    }

}

// MARK: - Previews
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
