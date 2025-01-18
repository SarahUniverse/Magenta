//
//  AccountViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/13/25.
//

import CoreData
import SwiftUI

final class AccountViewModel: ObservableObject {
    @Published var shouldShowLoginView = false
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        // Do any initial set here to get data.
    }

    func signOut() {
        self.shouldShowLoginView = true
    }

}
