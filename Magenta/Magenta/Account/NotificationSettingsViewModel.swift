//
//  NotificationSettingsViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData

class NotificationSettingsViewModel: ObservableObject {
    @Published var enableNotifications = false
    @Published var dailyReminders = false
    @Published var weeklySummary = false
    @Published var achievementAlerts = false
    @Published var communityUpdates = false
    @Published var enableQuietHours = false
    @Published var quietHoursStart = Date()
    @Published var quietHoursEnd = Date()
    @Published var newsletterEmails = false
    @Published var productUpdateEmails = false
    @Published var communityDigestEmails = false

    func requestNotificationPermission() {
        // Implement notification permission request
    }
}
