//
//  MoreViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/8/25.
//

import CoreData
import SwiftUI

final class MoreViewModel: ObservableObject {
    @Published var shouldShowLoginView = false
    @Published var navigationTitle = "More"
    @Published var currentUser: UserModel?
    @Published var error: String = ""

    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext, currentUser: UserModel? = nil) {
        self.viewContext = viewContext
        self.currentUser = currentUser
    }

    @Published var items: [(icon: String, title: String)] = [
        ("fork.knife", "Nutrition"),
        ("circle.dotted", "Cycle"),
        ("moon.zzz", "Sleep"),
        ("gearshape", "Settings"),
        ("magnifyingglass", "Find a Therapist"),
        ("pencil.and.scribble", "Journal"),
        ("music.note", "Mental Health Playlists"),
        ("book", "Self Help Books"),
        ("quote.bubble", "Helpful Quotes"),
        ("paintpalette", "Art Therapy")
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - Methods
    func handleItemTap(at index: Int) {
        print("\(items[index].title) button tapped")
        // Add navigation or action logic here
    }

    func signOut() {
        do {
            if let username = currentUser?.username {
                try KeychainManager.shared.deletePasswordFromKeychain(for: username)
            }

            if let username = currentUser?.username {
                let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "username == %@", username)
            }

            self.currentUser = nil

            self.shouldShowLoginView = true

        } catch {
            print("Error during sign out: \(error.localizedDescription)")
        }
    }

}

extension MoreViewModel {
    static func createPreviewViewModel() -> MoreViewModel {
        let container = NSPersistentContainer(name: "Model")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
        return MoreViewModel(viewContext: container.viewContext)
    }
}
