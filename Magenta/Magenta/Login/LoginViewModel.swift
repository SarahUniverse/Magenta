//
//  LoginViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import AuthenticationServices
import CoreData
import Foundation
import GoogleSignIn
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var error: String = ""
    @Published var isNavigating = false
    @Published var isLoggedIn = false
    @Published var userInfo = ""

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    func loginUser() {
        do {
            try KeychainManager.shared.savePasswordToKeychain(password: password, for: username)
        } catch {
            self.error = "Failed to save password: \(error.localizedDescription)"
        }
    }

    func checkPassword() {
        do {
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@", username)

            if let userEntity = try viewContext.fetch(fetchRequest).first {
                let userModel = UserModel(entity: userEntity)
                let storedPassword = try KeychainManager.shared.retrievePasswordFromKeychain(for: username)

                if password == storedPassword {
                    self.isLoggedIn = true
                    self.error = ""
                    self.currentUser = userModel
                } else {
                    self.error = "Incorrect password."
                }
            } else {
                self.error = "User not found. Please check credentials."
            }
        } catch KeychainManager.KeychainError.itemNotFound {
            self.error = "User not found. Please check credentials."
        } catch {
            self.error = "An error occurred: \(error.localizedDescription)"
        }
    }

    func signInWithGoogle() {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("Root view controller not found")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            guard let profile = result?.user.profile else { return }
            self.userInfo = """
            Success: {
              Given Name: \(profile.givenName ?? "None")
              Family Name: \(profile.familyName ?? "None")
              Name: \(profile.name)
              Email: \(profile.email)
              Profile Photo: \(profile.imageURL(withDimension: 320)?.absoluteString ?? "None");
            }
            """
            self.isNavigating = true
        }
    }

    func setupAppleSignInButton() -> SignInWithAppleButton {
        return SignInWithAppleButton(.signIn) { [weak self] request in
            request.requestedScopes = [.fullName, .email]
            self?.signInWithApple(request: request)
        } onCompletion: { [weak self] result in
            switch result {
            case .success:
                self?.isNavigating = true
                print("Authorization successful")
            case .failure(let error):
                print("Authorization failed: \(error.localizedDescription)")
            }
        }
    }

    func signInWithApple(request: ASAuthorizationAppleIDRequest) {
        // Implement Apple Sign-In logic here
    }
}
