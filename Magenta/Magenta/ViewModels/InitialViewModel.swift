//
//  InitialViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import SwiftData
import SwiftUI

class InitialViewModel: ObservableObject {
    @Published var username: String = ""
    private let keychainManager = KeychainManager.shared
    private var modelContext: ModelContext?

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        if let context = modelContext {
            self.loadUsernameFromSwiftData(context: context)
        }
    }

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadUsernameFromSwiftData(context: context)
    }

    private func loadUsernameFromSwiftData(context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<UserModel>()
        do {
            let users = try context.fetch(fetchDescriptor)
            if let firstUser = users.first {
                self.username = firstUser.name
            }
        } catch {
            print("Failed to load username from SwiftData: \(error.localizedDescription)")
        }
    }

    func isUserLoggedIn() -> Bool {
        guard let context = modelContext else {
            print("Model context is not set.")
            return false
        }

        let fetchDescriptor = FetchDescriptor<UserModel>()
        do {
            let users = try context.fetch(fetchDescriptor)
            return !users.isEmpty
        } catch {
            print("Error fetching users from SwiftData: \(error.localizedDescription)")
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
        guard let context = modelContext else {
            print("Model context is not set.")
            return nil
        }

        guard isUserLoggedIn() else { return nil }

        do {
            // Retrieve user ID and name from Keychain
            let userId = try keychainManager.retrievePasswordFromKeychain(for: username)

            // Attempt to fetch user from SwiftData first
            if let existingUser = fetchUser(id: userId, context: context) {
                return existingUser
            }

            // If user doesn't exist in SwiftData, retrieve the username from Keychain
            guard let userName = keychainManager.retrieveAccountNameFromKeychain(for: username) else {
                throw KeychainManager.KeychainError.itemNotFound
            }

            // Create and save a new user if not found in SwiftData
            let newUser = UserModel(id: userId, name: userName)
            context.insert(newUser)
            try context.save() // Now `context` is safely unwrapped

            return newUser
        } catch KeychainManager.KeychainError.itemNotFound {
            print("No user data found in Keychain.")
            return nil
        } catch {
            print("Failed to retrieve or process user from Keychain: \(error.localizedDescription)")
            return UserModel(id: "defaultId", name: "DefaultUser")
        }
    }

    private func fetchUser(id: String, context: ModelContext) -> UserModel? {
        let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { $0.id == id })
        do {
            return try context.fetch(descriptor).first
        } catch {
            print("Error fetching user by ID: \(error)")
            return nil
        }
    }

}
