//
//  InitialViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import CoreData
import SwiftUI

@Observable class ContentViewModel {
    var username: String = ""
    private let keychainManager = KeychainManager.shared
    private var viewContext: NSManagedObjectContext
    var userModel: UserModel?
    private var signUpViewModel: SignUpViewModel

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.signUpViewModel = SignUpViewModel(viewContext: viewContext)
    }

    /*func isUserLoggedIn() -> Bool {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let users = try viewContext.fetch(fetchRequest)
            return !users.isEmpty && users.contains { user in
                return verifyUserInKeychain(userId: user.username ?? "unknown")
            }
        } catch {
            print("Error fetching users from CoreData: \(error.localizedDescription)")
            return false
        }
    }*/


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

extension ContentViewModel {
    static func preview(viewContext: NSManagedObjectContext) -> ContentViewModel {
        let viewModel = ContentViewModel(viewContext: viewContext)
        // Add any preview data setup here
        return viewModel
    }

}
