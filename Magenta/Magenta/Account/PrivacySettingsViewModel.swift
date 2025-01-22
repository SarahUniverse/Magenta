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

class PrivacySettingsViewModel: ObservableObject {
    @Published var isPrivateAccount = false
    @Published var showOnlineStatus = true
    @Published var showActivityStatus = true
    @Published var shareUsageData = true
    @Published var personalizedRecommendations = true
    @Published var thirdPartyIntegration = false
    @Published var profileVisibility = ProfileVisibility.everyone
    @Published var contactPermission = ContactPermission.everyone
    @Published var showingAlert = false
    @Published var alertMessage = ""

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
