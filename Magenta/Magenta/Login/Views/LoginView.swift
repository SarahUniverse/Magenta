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

    init(viewContext: NSManagedObjectContext) {
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(viewContext: viewContext))
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
                        MainView(user: UserModel(id: "", name: ""))
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

    // TODO: There must be a more efficient way to do this
    // Setup a CoreData stack for preview
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourModelName")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
        return container
    }()

    return LoginView(viewContext: persistentContainer.viewContext)
}
