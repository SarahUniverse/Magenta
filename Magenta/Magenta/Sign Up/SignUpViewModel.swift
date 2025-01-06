//
//  SignUpViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import SwiftData
import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var isSignUpSuccessful: Bool = false

    private var modelContext: ModelContext?

    private let keychainManager = KeychainManager.shared

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    func validateFields() -> Bool {
        guard !username.isEmpty, !password.isEmpty, !email.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill out all fields."
            return false
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }

        // Basic email validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: email) {
            errorMessage = "Please enter a valid email address."
            return false
        }

        return true
    }

    func signUp() {
        guard let modelContext = modelContext else {
            errorMessage = "Model context is not set."
            return
        }

        if validateFields() {
            do {
                try keychainManager.savePasswordToKeychain(password: password, for: username)
                guard let accountName = keychainManager.retrieveAccountNameFromKeychain(for: username) else {
                    throw KeychainManager.KeychainError.itemNotFound
                }

                let newUser = UserModel(id: UUID().uuidString, name: accountName)
                modelContext.insert(newUser)

                try modelContext.save()

                isSignUpSuccessful = true
                errorMessage = ""
            } catch let error as KeychainManager.KeychainError {
                errorMessage = "Keychain error: \(error)"
            } catch {
                errorMessage = "Failed to save data: \(error.localizedDescription)"
            }
        }
    }

    func doesUserExist(for account: String) -> Bool {
        do {
            _ = try keychainManager.retrievePasswordFromKeychain(for: account)
            return true
        } catch KeychainManager.KeychainError.itemNotFound {
            return false
        } catch {
            print("Error checking user existence: \(error.localizedDescription)")
            return false // Assuming any other error means the user doesn't exist or we can't tell
        }
    }

}
