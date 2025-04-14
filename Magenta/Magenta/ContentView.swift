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
    @State private var biometricAuthViewModel: BiometricAuthViewModel
    @State private var signUpViewModel: SignUpViewModel

    @State private var currentUser: String = ""

    public init(viewContext: NSManagedObjectContext) {
        _contentViewModel = State(wrappedValue: ContentViewModel(viewContext: viewContext))
        _loginViewModel = State(wrappedValue: LoginViewModel(viewContext: viewContext))
        _biometricAuthViewModel = State(wrappedValue: BiometricAuthViewModel())
        _signUpViewModel = State(wrappedValue: SignUpViewModel(viewContext: viewContext))
    }

    public var body: some View {
        Group {
            if signUpViewModel.isUserSignedUp() == false {
                LandingPageView(viewContext: viewContext)
            } else if loginViewModel.isUserLoggedIn() == false {
                LoginView(viewContext: viewContext)
            } else {
            MainTabView(viewContext: viewContext, userModel: loginViewModel.userModel!)
                .onAppear {
                    loginViewModel.loadSavedUser()
                    currentUser = loginViewModel.username
                }
            }
        }
        .onAppear {
            loginViewModel.loadSavedUser()
           // signUpViewModel.isUserSignedUp()
           // loginViewModel.isUserLoggedIn()
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
            }
        }
        .task {
            if contentViewModel.isUserLoggedIn() {
                await MainActor.run {
                    biometricAuthViewModel.authenticateWithFaceID()
                }
            }
        }*/
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
