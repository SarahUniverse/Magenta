//
//  SignUpViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import CoreData
import SwiftUI

@Observable class SignUpViewModel {
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var errorMessage: String = ""
    var userModel: UserModel?
    var isSignUpSuccessful: Bool = false

    private var viewContext: NSManagedObjectContext
    private let keychainManager = KeychainManager.shared

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    func isUserSignedUp() -> Bool {
        if let user = userModel, user.isUserSignedUp {
            return true
        }

        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isUserSignedUp == %@", NSNumber(value: true))

        do {
            let signedUpUsers = try viewContext.fetch(fetchRequest)
            if let signedUpUser = signedUpUsers.first {
                self.userModel = UserModel(entity: signedUpUser)
                return true
            }
        } catch {
            print("Error checking signed-up user: \(error.localizedDescription)")
        }

        return false
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

    func deleteAllUsers(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            print("Error deleting users: \(error.localizedDescription)")
        }
    }

    func signUp() {

        if validateFields() {
            do {
                let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "username == %@ OR email == %@", username, email)

                let existingUsers = try viewContext.fetch(fetchRequest)
                print("Existing users found: \(existingUsers.count)")

                guard existingUsers.isEmpty else {
                    errorMessage = "Username or email already exists"
                    print("Error: \(errorMessage)")
                    return
                }

                try keychainManager.savePasswordToKeychain(password: password, for: username)

                // Create a new UserEntity
                let newUserEntity = UserEntity(context: viewContext)
                newUserEntity.id = UUID()
                newUserEntity.username = username
                newUserEntity.email = email
                newUserEntity.isUserSignedUp = true

                try viewContext.save()

                userModel = UserModel(entity: newUserEntity)

                isSignUpSuccessful = true
                errorMessage = ""
                let fetchRequestTwo: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                do {
                    let allUsers = try viewContext.fetch(fetchRequestTwo)
                    print("All users in Core Data: \(allUsers.map { $0.username ?? "nil" })")
                } catch {
                    print("Error fetching all users: \(error.localizedDescription)")
                }
            } catch let error as KeychainManager.KeychainError {
                errorMessage = "Keychain error: \(error)"
            } catch {
                errorMessage = "Failed to save data: \(error.localizedDescription)"
                print("Error saving data: \(error.localizedDescription)")
            }
        } else {
            print("Validation failed with error: \(errorMessage)")
        }
    }

    func doesUserExist(for account: String) -> Bool {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", account)

        do {
            let results = try viewContext.fetch(fetchRequest)
            print("Checking existence for account: \(account), found: \(results.count) users")
            return !results.isEmpty
        } catch {
            print("Error checking user existence: \(error.localizedDescription)")
            return false
        }
    }

}
