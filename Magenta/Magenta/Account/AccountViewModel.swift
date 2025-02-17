//
//  AccountViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/13/25.
//

import CoreData
import SwiftUI

final class AccountViewModel: ObservableObject {
    @Published var shouldShowLoginView = false
    @Published var showingDeleteAlert = false
    @Published var isDarkMode = false
    @Published var selectedLanguage = "English"
    let viewContext: NSManagedObjectContext
    @Published var colors: Colors

    // User Info
    @Published var userName = "Orko C. Puppy"
    @Published var userEmail = "Orko@puppy.com"

    // Settings
    let availableLanguages = ["English", "Spanish", "French", "German"]

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        self.viewContext = viewContext
        self.colors = Colors(colorScheme: colorScheme)
        // Initialize other properties as needed
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
