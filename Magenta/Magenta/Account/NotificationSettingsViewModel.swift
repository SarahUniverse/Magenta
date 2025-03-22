//
//  NotificationSettingsViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData

@Observable final class NotificationSettingsViewModel {
    var enableNotifications = false
    var dailyReminders = false
    var weeklySummary = false
    var achievementAlerts = false
    var communityUpdates = false
    var enableQuietHours = false
    var quietHoursStart = Date()
    var quietHoursEnd = Date()
    var newsletterEmails = false
    var productUpdateEmails = false
    var communityDigestEmails = false

    func requestNotificationPermission() {
        // Implement notification permission request
    }
}
