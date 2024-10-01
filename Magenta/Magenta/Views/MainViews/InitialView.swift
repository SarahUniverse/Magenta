//
//  InitialView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftData
import SwiftUI

public struct InitialView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var initialViewModel = InitialViewModel()
    @StateObject private var signUpViewModel = SignUpViewModel()

    public var body: some View {
        Group {
            if let currentUser = initialViewModel.getCurrentUser() {
                if initialViewModel.isUserLoggedIn() {
                    MainView(user: currentUser)
                } else {
                    LoginView()
                }
            } else {
                SignUpView()
            }
        }
        .onAppear {
            initialViewModel.setModelContext(modelContext)
        }
    }
}
