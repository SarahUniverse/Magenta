//
//  SignUpView.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import CoreData
import SwiftUI

struct SignUpView: View {
    @State private var signUpViewModel: SignUpViewModel
    @State private var showMainView = false
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        _signUpViewModel = State(wrappedValue: SignUpViewModel(viewContext: viewContext))
        self.viewContext = viewContext
    }

    // MARK: - Body
    var body: some View {
        VStack {
            headerView
            formFields
            signUpButton
            errorMessage
            Spacer()
            CopyrightView()
                .padding(.top, 80)
        }
        .alert(isPresented: $signUpViewModel.isSignUpSuccessful) {
            Alert(
                title: Text("Success"),
                message: Text("Your account has been created."),
                dismissButton: .default(Text("OK")) {
                    showMainView = true
                }
            )
        }
        .fullScreenCover(isPresented: $showMainView) {
            if let userEntity = signUpViewModel.userModel {
                MainTabView(viewContext: viewContext, userModel: userEntity)
            }
        }
        .background(AppGradients.backgroundGradient)
    }

    // MARK: - Private Variables
    private var headerView: some View {
        Text("Welcome to Magenta")
            .padding(.top, 50)
            .foregroundStyle(.white)
            .font(.largeTitle.weight(.semibold))
            .shadow(color: .pinkPurple, radius: 5)
            .shadow(color: .pinkPurple, radius: 5)
            .shadow(color: .darkBlue, radius: 3)
            .shadow(color: .pinkPurple, radius: 50)
    }

    private var formFields: some View {
        VStack(alignment: .leading) {
            formField(title: "Username", text: $signUpViewModel.username)
            formField(title: "Email", text: $signUpViewModel.email)
            secureFormField(title: "Password", text: $signUpViewModel.password)
            secureFormField(title: "Confirm Password", text: $signUpViewModel.confirmPassword)
        }
        .padding(20)
    }

    private var signUpButton: some View {
        Button {
            if signUpViewModel.doesUserExist(for: signUpViewModel.username) {
                signUpViewModel.errorMessage = "User already exists. Please log in or use a different username."
            } else {
                signUpViewModel.signUp()
            }
        } label: {
            Text("Sign Up")
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

    private var errorMessage: some View {
        Text(signUpViewModel.errorMessage)
            .foregroundStyle(.red)
            .padding()
    }

    private var successAlert: Alert {
        Alert(
            title: Text("Success"),
            message: Text("Your account has been created."),
            dismissButton: .default(Text("OK")) {
                showMainView = true
            }
        )
    }

    private var mainViewDestination: some View {
        Group {
            if let userEntity = signUpViewModel.userModel {
                MainTabView(viewContext: viewContext, userModel: userEntity)
            }
        }
    }

    // MARK: - Private Functions for Views
    private func formField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.7))
            TextField("Enter \(title.lowercased())", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
        }
    }

    private func secureFormField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.7))
            SecureField("\(title.lowercased())", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
        }
    }

}

// MARK: - Previews
#Preview ("Light Mode") {
    let container = NSPersistentContainer(name: "Model")
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    return SignUpView(viewContext: container.viewContext)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let container = NSPersistentContainer(name: "Model")
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }

    return SignUpView(viewContext: container.viewContext)
        .preferredColorScheme(.dark)
}
