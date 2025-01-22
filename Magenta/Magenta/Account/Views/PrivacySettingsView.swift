//
//  PrivacySettingsView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct PrivacySettingsView: View {
    @StateObject private var viewModel = PrivacySettingsViewModel()

    var body: some View {
        List {
            Section("Account Privacy") {
                Toggle("Private Account", isOn: $viewModel.isPrivateAccount)
                Toggle("Show Online Status", isOn: $viewModel.showOnlineStatus)
                Toggle("Show Activity Status", isOn: $viewModel.showActivityStatus)
            }

            Section("Data Sharing") {
                Toggle("Share Usage Data", isOn: $viewModel.shareUsageData)
                Toggle("Personalized Recommendations", isOn: $viewModel.personalizedRecommendations)
                Toggle("Third-Party Integration", isOn: $viewModel.thirdPartyIntegration)
            }

            Section("Content") {
                Picker("Who Can See My Profile", selection: $viewModel.profileVisibility) {
                    ForEach(ProfileVisibility.allCases) { visibility in
                        Text(visibility.rawValue).tag(visibility)
                    }
                }

                Picker("Who Can Contact Me", selection: $viewModel.contactPermission) {
                    ForEach(ContactPermission.allCases) { permission in
                        Text(permission.rawValue).tag(permission)
                    }
                }
            }

            Section("Data Management") {
                Button("Download My Data") {
                    viewModel.downloadData()
                }

                Button("Clear Search History") {
                    viewModel.clearSearchHistory()
                }

                Button("Clear Cache") {
                    viewModel.clearCache()
                }
            }

            Section("Blocked Users") {
                NavigationLink("Manage Blocked Users") {
                    BlockedUsersView()
                }
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Clear Data", isPresented: $viewModel.showingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.confirmClearData()
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    PrivacySettingsView()
}
