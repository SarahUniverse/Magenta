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

    init (viewContext: NSManagedObjectContext, currentUser: UserModel? = nil) {
        self.viewContext = viewContext
        self.currentUser = currentUser
    }

    func signOut() {
        self.shouldShowLoginView = true
    }
}

extension SummaryViewModel {
    static func createPreviewViewModel() -> SummaryViewModel {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
        return SummaryViewModel(viewContext: container.viewContext)
    }
}
