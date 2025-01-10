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
    @Published var createdUserModel: UserModel?

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

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: email) {
            errorMessage = "Please enter a valid email address."
            return false
        }

        return true
    }

    func signUp() {
        print("Attempting to sign up with username: \(username), email: \(email)") // Debugging line

        if validateFields() {
            do {
                let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "username == %@ OR email == %@", username, email)

                let existingUsers = try viewContext.fetch(fetchRequest)
                print("Existing users found: \(existingUsers.count)") // Debugging line

                guard existingUsers.isEmpty else {
                    errorMessage = "Username or email already exists"
                    print("Error: \(errorMessage)") // Debugging line
                    return
                }

                // Save password to Keychain
                try keychainManager.savePasswordToKeychain(password: password, for: username)
                print("Password saved to Keychain for username: \(username)") // Debugging line

                // Create a new UserEntity
                let newUserEntity = UserEntity(context: viewContext)
                newUserEntity.id = UUID()
                newUserEntity.username = username // Ensure username is non-optional
                newUserEntity.email = email // Ensure email is non-optional
                print("New user created with username: \(newUserEntity.username ?? "nil"), email: \(newUserEntity.email ?? "nil")") // Debugging line

                // Save the context
                try viewContext.save()
                print("User saved to Core Data successfully.") // Debugging line

                // Initialize the UserModel with the new UserEntity
                createdUserModel = UserModel(entity: newUserEntity)

                // Indicate success
                isSignUpSuccessful = true
                errorMessage = ""
                print("Sign up successful for username: \(username)") // Debugging line
                let fetchRequestTwo: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                do {
                    let allUsers = try viewContext.fetch(fetchRequestTwo)
                    print("All users in Core Data: \(allUsers.map { $0.username ?? "nil" })") // Debugging line
                } catch {
                    print("Error fetching all users: \(error.localizedDescription)")
                }
            } catch let error as KeychainManager.KeychainError {
                errorMessage = "Keychain error: \(error)"
                print("Keychain error: \(error)") // Debugging line
            } catch {
                errorMessage = "Failed to save data: \(error.localizedDescription)"
                print("Error saving data: \(error.localizedDescription)") // Debugging line
            }
        } else {
            print("Validation failed with error: \(errorMessage)") // Debugging line
        }
    }

    func doesUserExist(for account: String) -> Bool {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", account)

        do {
            let results = try viewContext.fetch(fetchRequest)
            print("Checking existence for account: \(account), found: \(results.count) users") // Debugging line
            return !results.isEmpty
        } catch {
            print("Error checking user existence: \(error.localizedDescription)")
            return false
        }
    }
}
