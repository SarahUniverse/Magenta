//
//  CoreDataStack.swift
//  Magenta
//
//  Created by Sarah Clark on 1/6/25.
//

import Combine
import CoreData

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()

    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {

        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "CoreData")

        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()

    private init() { }
}
