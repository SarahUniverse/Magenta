//
//  NotificationSettingsView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct NotificationSettingsView: View {
    @StateObject private var viewModel = NotificationSettingsViewModel()

    var body: some View {
        List {
            Section("Push Notifications") {
                Toggle("Enable Notifications", isOn: $viewModel.enableNotifications)
                    .onChange(of: viewModel.enableNotifications) {
                        viewModel.requestNotificationPermission()
                    }
            }

            if viewModel.enableNotifications {
                Section("Notification Types") {
                    Toggle("Daily Reminders", isOn: $viewModel.dailyReminders)
                    Toggle("Weekly Summary", isOn: $viewModel.weeklySummary)
                    Toggle("Achievement Alerts", isOn: $viewModel.achievementAlerts)
                    Toggle("Community Updates", isOn: $viewModel.communityUpdates)
                }

                Section("Quiet Hours") {
                    Toggle("Enable Quiet Hours", isOn: $viewModel.enableQuietHours)

                    if viewModel.enableQuietHours {
                        DatePicker("Start Time", selection: $viewModel.quietHoursStart, displayedComponents: .hourAndMinute)
                        DatePicker("End Time", selection: $viewModel.quietHoursEnd, displayedComponents: .hourAndMinute)
                    }
                }

                Section("Email Notifications") {
                    Toggle("Newsletter", isOn: $viewModel.newsletterEmails)
                    Toggle("Product Updates", isOn: $viewModel.productUpdateEmails)
                    Toggle("Community Digest", isOn: $viewModel.communityDigestEmails)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Previews
#Preview("Light Mode"){
    NotificationSettingsView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode"){
    NotificationSettingsView()
        .preferredColorScheme(.dark)
}
