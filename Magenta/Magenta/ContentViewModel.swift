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

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.loadUsernameFromCoreData()
    }

    private func loadUsernameFromCoreData() {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let users = try viewContext.fetch(fetchRequest)
            if let firstUser = users.first {
                self.username = firstUser.username ?? ""
            }
        } catch {
            print("Failed to load username from CoreData: \(error.localizedDescription)")
        }
    }

    func isUserLoggedIn() -> Bool {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let users = try viewContext.fetch(fetchRequest)
            return !users.isEmpty && verifyUserInKeychain(userId: username)
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

    func getCurrentUser() -> UserEntity? {
        guard isUserLoggedIn() else { return nil }

        do {
            // Retrieve user from CoreData
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@", username)
            print("The username is: \(username)")

            let results = try viewContext.fetch(fetchRequest)
            if let existingUser = results.first {
                return existingUser
            }

            // If user doesn't exist in CoreData but exists in Keychain, create new CoreData entry
            guard let userName = keychainManager.retrieveAccountNameFromKeychain(for: username) else {
                throw KeychainManager.KeychainError.itemNotFound
            }

            // Create and save a new user
            let newUser = UserEntity(context: viewContext)
            newUser.id = UUID()
            newUser.username = userName
            newUser.email = "" // Set email if available

            try viewContext.save()

            return newUser

        } catch KeychainManager.KeychainError.itemNotFound {
            print("No user data found in Keychain.")
            return nil
        } catch {
            print("Failed to retrieve or process user: \(error.localizedDescription)")
            return nil
        }
    }

    private func fetchUser(username: String) -> UserEntity? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            return try viewContext.fetch(fetchRequest).first
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
