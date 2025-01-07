//
//  LoginView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import CoreData
import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel: LoginViewModel
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(viewContext: viewContext))
        self.viewContext = viewContext
    }

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.lightPurple,
            Color.darkPurple,
            Color.darkBlue,
            Color.black
        ]),
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Magenta")
                    .padding(.top, 30)
                    .foregroundStyle(.white)
                    .font(.largeTitle)

                TextField("Username", text: $loginViewModel.username)
                    .padding(20)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)

                SecureField("Password", text: $loginViewModel.password)
                    .padding(20)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)

                Button(action: {
                    loginViewModel.checkPassword()
                    if loginViewModel.isLoggedIn {
                        loginViewModel.isNavigating = true
                    }
                }, label: {
                    Text("Login")
                        .bold()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.mediumBlue)
                        .cornerRadius(10)
                })
                .padding(20)

                Text(loginViewModel.error)
                    .foregroundColor(.red)
                    .navigationDestination(isPresented: $loginViewModel.isNavigating) {
                        if let currentUser = loginViewModel.currentUser {
                            MainView(viewContext: viewContext, userModel: currentUser)
                        } else {
                            Text("Error loading user")
                        }
                    }

                Text("Or sign in with")
                    .foregroundColor(.white)
                    .bold()

                CustomGoogleSignInButton(action: loginViewModel.signInWithGoogle)
                    .frame(height: 40)
                    .padding(20)

                loginViewModel.setupAppleSignInButton()
                    .containerRelativeFrame(.vertical, count: 8, spacing: 60)
                    .padding(20)
                    .signInWithAppleButtonStyle(.whiteOutline)
                Spacer()

                CopyrightView()
                Spacer()
            }
            .padding()
            .background(backgroundGradient)
        }
    }
}

#Preview {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model") // Make sure this matches your .xcdatamodeld file name
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
        return container
    }()

    return LoginView(viewContext: persistentContainer.viewContext)
}
