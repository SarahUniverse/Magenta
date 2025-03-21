//
//  SummaryViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/7/25.
//

import CoreData
import SwiftUI

@Observable final class SummaryViewModel {
    var shouldShowLoginView = false
    var currentUser: UserModel?
    var colors: Colors
    var pinnedItems: [String] = []
    let viewContext: NSManagedObjectContext

    init (viewContext: NSManagedObjectContext, currentUser: UserModel? = nil, colorScheme: ColorScheme) {
        self.viewContext = viewContext
        self.colors = Colors(colorScheme: colorScheme)
        self.currentUser = currentUser
        loadPinnedItems()
    }

    func signOut() {
        self.shouldShowLoginView = true
    }

    func updateColorScheme(_ colorScheme: ColorScheme) {
        colors = Colors(colorScheme: colorScheme)
    }

    func savePinnedItems() {
        let deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PinnedItemEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: deleteRequest)
        _ = try? viewContext.execute(batchDeleteRequest)

        for item in pinnedItems {
            let pinnedItem = PinnedItemEntity(context: viewContext)
            pinnedItem.name = item
        }

        do {
            try viewContext.save()
        } catch {
            print("Error saving pinned items: \(error)")
        }
    }

    private func loadPinnedItems() {
        let request: NSFetchRequest<PinnedItemEntity> = PinnedItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        do {
            let items = try viewContext.fetch(request)
            pinnedItems = items.map { $0.name ?? "" }
        } catch {
            print("Error loading pinned items: \(error)")
        }
    }

}
