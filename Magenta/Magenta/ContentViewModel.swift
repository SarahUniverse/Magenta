//
//  InitialViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import CoreData
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var username: String = ""
    private let keychainManager = KeychainManager.shared
    private var viewContext: NSManagedObjectContext
    @Published var userModel: UserModel?

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.loadCurrentUser()
    }

    private func loadCurrentUser() {
        print("Loading current user...") // Debugging line
        if let currentUser = getCurrentUser() {
            self.userModel = currentUser
            self.username = currentUser.username
            print("Loaded current user: \(currentUser.username)") // Debugging line
        } else {
            print("No current user found.") // Debugging line
        }
    }

    func isUserLoggedIn() -> Bool {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let users = try viewContext.fetch(fetchRequest)
            print("Current username: \(String(describing: userModel?.username))") // Debugging line
            return !users.isEmpty && verifyUserInKeychain(userId: userModel?.username ?? "nothing")
        } catch {
            print("Error fetching users from CoreData: \(error.localizedDescription)")
            return false
        }
    }

    private func verifyUserInKeychain(userId: String) -> Bool {
        do {
            _ = try keychainManager.retrievePasswordFromKeychain(for: userId)
            return true
        } catch KeychainManager.KeychainError.itemNotFound {
            return false
        } catch {
            print("Keychain access error: \(error.localizedDescription)")
            return false
        }
    }

    func getCurrentUser() -> UserModel? {
        guard isUserLoggedIn() else { return nil }

        do {
            // Retrieve user from CoreData
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@", username)
            print("The username is: \(username)") // Debugging line

            let results = try viewContext.fetch(fetchRequest)
            if let existingUser = results.first {
                let userModel = UserModel(entity: existingUser)
                print("UserModel created with username: \(userModel.username), email: \(userModel.email)") // Debugging line
                return userModel
            }

            // If user not found in Core Data, check Keychain
            guard let userName = keychainManager.retrieveAccountNameFromKeychain(for: username) else {
                throw KeychainManager.KeychainError.itemNotFound
            }

            // Create a new UserEntity if not found
            let newUser = UserEntity(context: viewContext)
            newUser.id = UUID()
            newUser.username = userName
            newUser.email = ""

            try viewContext.save()

            return UserModel(entity: newUser)

        } catch KeychainManager.KeychainError.itemNotFound {
            print("No user data found in Keychain.")
            return nil
        } catch {
            print("Failed to retrieve or process user: \(error.localizedDescription)")
            return nil
        }
    }

    private func fetchUser(username: String) -> UserModel? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            if let userEntity = try viewContext.fetch(fetchRequest).first {
                return UserModel(entity: userEntity)
            }
            return nil
        } catch {
            print("Error fetching user by username: \(error)")
            return nil
        }
    }
}

// Extension for testing and preview support
extension ContentViewModel {
    static func preview(viewContext: NSManagedObjectContext) -> ContentViewModel {
        let viewModel = ContentViewModel(viewContext: viewContext)
        // Add any preview data setup here
        return viewModel
    }
}
