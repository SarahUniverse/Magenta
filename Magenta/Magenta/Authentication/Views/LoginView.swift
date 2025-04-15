//
//  LoginView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import CoreData
import SwiftUI

struct LoginView: View {
    @State private var loginViewModel: LoginViewModel
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        _loginViewModel = State(wrappedValue: LoginViewModel(viewContext: viewContext))
        self.viewContext = viewContext
    }

    // MARK: - Body
    var body: some View {
        VStack {
            headerView
            loginFields
            loginButton
            errorView
            divider
            socialLoginButtons
            Spacer()
            CopyrightView()
                .padding(.top, 100)
        }
        .padding()
        .background(AppGradients.backgroundGradient)
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Private Variables
    private var headerView: some View {
        Text("Welcome to Magenta")
            .padding(.top, 50)
            .padding(.bottom, 30)
            .foregroundStyle(.white)
            .font(.largeTitle.weight(.semibold))
            .shadow(color: .pinkPurple, radius: 5)
            .shadow(color: .pinkPurple, radius: 5)
            .shadow(color: .darkBlue, radius: 3)
            .shadow(color: .pinkPurple, radius: 50)
    }

    private var loginFields: some View {
        VStack {
            usernameField
            passwordField
        }
    }

    private var usernameField: some View {
        TextField("Username", text: $loginViewModel.username)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
    }

    private var passwordField: some View {
        SecureField("Password", text: $loginViewModel.password)
            .padding(.horizontal, 20)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
    }

    private var loginButton: some View {
        Button {
            loginViewModel.checkPassword()
            if loginViewModel.isLoggedIn {
                loginViewModel.isNavigating = true
            }
        } label: {
            Text("Login")
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
        .padding(20)
    }

    private var errorView: some View {
        Text(loginViewModel.error)
            .foregroundStyle(.red)
            .fullScreenCover(isPresented: $loginViewModel.isNavigating) {
                destinationView
            }
    }

    private var destinationView: some View {
        Group {
            if let currentUser = loginViewModel.userModel {
                MainTabView(viewContext: viewContext, userModel: currentUser)
            } else {
                Text("Error loading user")
            }
        }
    }

    private var divider: some View {
        Text("Or sign in with")
            .foregroundStyle(.white)
            .bold()
            .shadow(radius: 1)
    }

    private var socialLoginButtons: some View {
        VStack {
            googleSignInButton
            appleSignInButton
        }
    }

    private var googleSignInButton: some View {
        CustomGoogleSignInButton(action: loginViewModel.signInWithGoogle)
            .frame(height: 40)
            .padding(20)
    }

    private var appleSignInButton: some View {
        loginViewModel.setupAppleSignInButton()
            .shadow(radius: 5)
            .containerRelativeFrame(.vertical, count: 8, spacing: 60)
            .padding(.horizontal, 20)
            .signInWithAppleButtonStyle(.white)
    }

}

// MARK: - Previews
#Preview ("Light Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
        return container
    }()

    return LoginView(viewContext: persistentContainer.viewContext)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
        return container
    }()

    return LoginView(viewContext: persistentContainer.viewContext)
        .preferredColorScheme(.dark)
}
