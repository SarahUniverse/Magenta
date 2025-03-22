//
//  AccountViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/13/25.
//

import CoreData
import SwiftUI

@Observable final class AccountViewModel {
    var shouldShowLoginView = false
    var showingDeleteAlert = false
    var isDarkMode = false
    var selectedLanguage = "English"
    let viewContext: NSManagedObjectContext
    var colors: Colors

    // User Info
    var userName = "Orko C. Puppy"
    var userEmail = "Orko@puppy.com"

    // Settings
    let availableLanguages = ["English", "Spanish", "French", "German"]

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        self.viewContext = viewContext
        self.colors = Colors(colorScheme: colorScheme)
    }

    func signOut() {
        self.shouldShowLoginView = true
    }

    func updateColorScheme(_ colorScheme: ColorScheme) {
        colors = Colors(colorScheme: colorScheme)
    }

    func deleteAccount() {
        showingDeleteAlert = true
    }

    func confirmDeleteAccount() {
        // Implement account deletion logic
        signOut()
    }

    func contactSupport() {
        // Implement support contact logic
    }

    func showPrivacyPolicy() {
        // Show privacy policy
    }

    func showTerms() {
        // Show terms of service
    }
}
