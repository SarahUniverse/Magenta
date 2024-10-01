//
//  LoginViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import Foundation
import SwiftUI
import SwiftData
import GoogleSignIn
import AuthenticationServices

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var error: String = ""
    @Published var isNavigating = false
    @Published var isLoggedIn = false
    @Published var userInfo = ""

    private var modelContext: ModelContext?

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
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
            let storedPassword = try KeychainManager.shared.retrievePasswordFromKeychain(for: username)
            if password == storedPassword {
                self.isLoggedIn = true
                self.error = ""
            } else {
                self.error = "Incorrect password."
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

    func signInWithApple(request: ASAuthorizationAppleIDRequest) {
        // Implement Apple sign in logic here or call it directly from the view if more appropriate
    }
}

// Dummy Item for Preview
@Model
class DummyItem {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
