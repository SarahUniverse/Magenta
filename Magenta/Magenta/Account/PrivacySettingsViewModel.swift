//
//  PrivacySettingsViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData

enum ProfileVisibility: String, CaseIterable, Identifiable {
    case everyone = "Everyone"
    case friends = "Friends Only"
    case none = "No One"

    var id: String { self.rawValue }
}

enum ContactPermission: String, CaseIterable, Identifiable {
    case everyone = "Everyone"
    case friends = "Friends Only"
    case none = "No One"

    var id: String { self.rawValue }
}

@Observable class PrivacySettingsViewModel {
    var isPrivateAccount = false
    var showOnlineStatus = true
    var showActivityStatus = true
    var shareUsageData = true
    var personalizedRecommendations = true
    var thirdPartyIntegration = false
    var profileVisibility = ProfileVisibility.everyone
    var contactPermission = ContactPermission.everyone
    var showingAlert = false
    var alertMessage = ""

    func downloadData() {
        // Implement download data logic
    }

    func clearSearchHistory() {
        showingAlert = true
        alertMessage = "Are you sure you want to clear your search history?"
    }

    func clearCache() {
        showingAlert = true
        alertMessage = "Are you sure you want to clear the cache?"
    }

    func confirmClearData() {
        // Implement clear data logic
    }
}
