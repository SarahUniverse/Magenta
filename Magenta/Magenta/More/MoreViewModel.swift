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
    @Published var isPresenting = false
    @Published var selectedView: AnyView?

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

        if items[index].title == "Art Therapy" {
            selectedView = AnyView(ArtTherapyView())
            isPresenting = true
        }

    }

    func signOut() {
        self.shouldShowLoginView = true
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
