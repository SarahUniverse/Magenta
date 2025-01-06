//
//  ContentView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

public struct ContentView: View {
    // Get a reference to the management object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject private var contentViewModel = ContentViewModel()
    @StateObject private var signUpViewModel = SignUpViewModel()

    public var body: some View {
        Group {
            if let currentUser = contentViewModel.getCurrentUser() {
                if contentViewModel.isUserLoggedIn() {
                    MainView(user: currentUser)
                } else {
                    LoginView(viewContext: viewContext)
                }
            } else {
                SignUpView()
            }
        }
        .onAppear {
            contentViewModel.setViewContext(viewContext)
        }
    }
}
