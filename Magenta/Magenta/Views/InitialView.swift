//
//  InitialView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftData
import SwiftUI

struct InitialView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var users: [User]

    var body: some View {
        if let currentUser = users.first(where: { $0.isLoggedIn }) {
            Overview(user: currentUser)
        } else {
            LoginView()
        }
    }

    func isUserLoggedIn() -> Bool {
        users.contains(where: { $0.isLoggedIn })
    }
}

