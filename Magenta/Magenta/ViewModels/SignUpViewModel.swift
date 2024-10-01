//
//  SignUpViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var isSignUpSuccessful: Bool = false

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
}
