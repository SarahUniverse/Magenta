//
//  CoreDataStack.swift
//  Magenta
//
//  Created by Sarah Clark on 1/6/25.
//

import CoreData

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "DataModel")

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()

    private init() { }
}
