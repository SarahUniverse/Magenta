//
//  SignUpViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import CoreData
import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var isSignUpSuccessful: Bool = false
    @Published var createdUserEntity: UserEntity?

    private var viewContext: NSManagedObjectContext
    private let keychainManager = KeychainManager.shared

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
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
        if validateFields() {
            do {
                // Check if user already exists
                let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "username == %@ OR email == %@", username, email)

                let existingUsers = try viewContext.fetch(fetchRequest)

                guard existingUsers.isEmpty else {
                    errorMessage = "Username or email already exists"
                    return
                }

                // Save password to keychain
                try keychainManager.savePasswordToKeychain(password: password, for: username)

                // Create new user entity
                let newUserEntity = UserEntity(context: viewContext)
                newUserEntity.id = UUID()
                newUserEntity.username = username
                newUserEntity.email = email

                // Save to Core Data
                try viewContext.save()

                // Create UserModel from entity
                _ = UserModel(entity: newUserEntity)

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
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", account)

        do {
            let results = try viewContext.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Error checking user existence: \(error.localizedDescription)")
            return false
        }
    }
}


