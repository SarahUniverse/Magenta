//
//  BlockedUsersView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct BlockedUsersView: View {
    @State private var viewModel = BlockedUserViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("Search blocked users", text: $viewModel.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
            }

            Section {
                if viewModel.filteredBlockedUsers.isEmpty {
                    Text("No blocked users")
                        .foregroundStyle(.gray)
                        .italic()
                } else {
                    ForEach(viewModel.filteredBlockedUsers) { user in
                        BlockedUserRow(user: user) {
                            viewModel.selectedUser = user
                            viewModel.showUnblockAlert = true
                        }
                    }
                }
            }
        }
        .navigationTitle("Blocked Users")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Unblock User", isPresented: $viewModel.showUnblockAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Unblock", role: .destructive) {
                if let user = viewModel.selectedUser {
                    viewModel.unblockUser(user)
                }
            }
        } message: {
            if let user = viewModel.selectedUser {
                Text("Are you sure you want to unblock \(user.name)? They will be able to interact with you again.")
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
            }
        }
    }
}

// MARK: Previews
#Preview("Light Mode") {
    NavigationStack {
        BlockedUsersView()
            .preferredColorScheme(.light)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        BlockedUsersView()
            .preferredColorScheme(.dark)
    }
}
