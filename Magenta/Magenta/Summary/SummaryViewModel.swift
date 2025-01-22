//
//  SummaryViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/7/25.
//

import CoreData
import SwiftUI

final class SummaryViewModel: ObservableObject {
    @Published var shouldShowLoginView = false
    @Published var currentUser: UserModel?
    let viewContext: NSManagedObjectContext
    @Published var colors: Colors
    @Published var pinnedItems: [String] = ["Mood", "Meditate", "Exercise"]

    init (viewContext: NSManagedObjectContext, currentUser: UserModel? = nil, colorScheme: ColorScheme) {
        self.viewContext = viewContext
        self.colors = Colors(colorScheme: colorScheme)
        self.currentUser = currentUser
    }

    func signOut() {
        self.shouldShowLoginView = true
    }

    func updateColorScheme(_ colorScheme: ColorScheme) {
        colors = Colors(colorScheme: colorScheme)
    }

}
