//
//  BlockedUsersViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData

final class BlockedUserViewModel: ObservableObject {
    @Published var blockedUsers: [BlockedUserModel] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var showUnblockAlert = false
    @Published var selectedUser: BlockedUserModel?
    @Published var errorMessage: String?

    var filteredBlockedUsers: [BlockedUserModel] {
        if searchText.isEmpty {
            return blockedUsers
        }
        return blockedUsers.filter { user in
            user.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    init() {
        fetchBlockedUsers()
    }

    func fetchBlockedUsers() {
        isLoading = true

        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Example data
            self.blockedUsers = [
                BlockedUserModel(id: "1", name: "John Doe", blockedDate: Date().addingTimeInterval(-86400)),
                BlockedUserModel(id: "2", name: "Jane Smith", blockedDate: Date().addingTimeInterval(-172800)),
                BlockedUserModel(id: "3", name: "Mike Johnson", blockedDate: Date().addingTimeInterval(-259200))
            ]
            self.isLoading = false
        }
    }

    func unblockUser(_ user: BlockedUserModel) {
        isLoading = true

        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.blockedUsers.removeAll { $0.id == user.id }
            self.isLoading = false
            self.selectedUser = nil
        }
    }
}
