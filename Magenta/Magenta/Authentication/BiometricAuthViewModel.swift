//
//  BiometricAuthViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 2/16/25.
//

import LocalAuthentication

@Observable final class BiometricAuthViewModel {
    var isAuthenticated = false
    var errorMessage = ""

    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?

        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Check the biometry type
            let reason = "Authenticate to access the app"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                    } else {
                        if let error = authenticationError {
                            self.errorMessage = self.handleBiometricError(error: error)
                        }
                    }
                }
            }
        } else {
            // No biometric authentication available
            errorMessage = "Face ID not available"
        }
    }

    private func handleBiometricError(error: Error) -> String {
        switch error {
            case LAError.authenticationFailed:
                return "Authentication failed"
            case LAError.userCancel:
                return "User canceled"
            case LAError.userFallback:
                return "User chose to use password"
            case LAError.biometryNotAvailable:
                return "Face ID is not available"
            case LAError.biometryNotEnrolled:
                return "Face ID is not set up"
            case LAError.biometryLockout:
                return "Face ID is locked"
            default:
                return "Face ID may not be configured"
            }
    }

}
