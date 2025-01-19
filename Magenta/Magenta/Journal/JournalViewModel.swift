//
//  JournalViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/18/25.
//

import CoreData
#if canImport(JournalingSuggestions)
import JournalingSuggestions
#endif
import SwiftUI

final class JournalViewModel: ObservableObject {
    @Published var journalEntries: [JournalModel] = []

    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        setupInitialJournalEntries()
    }

    func fetchJournalEntries() {
        let request: NSFetchRequest<JournalEntity> = JournalEntity.fetchRequest()

        do {
            let entities = try viewContext.fetch(request)
            journalEntries = entities.map { JournalModel(entity: $0)}
        } catch {
            print("Error fetching journal entries: \(error.localizedDescription)")
        }
    }

    func deleteJournalEntry(_ entry: JournalModel) {
        guard let entity = fetchEntity(for: entry) else { return }
        viewContext.delete(entity)

        do {
            try viewContext.save()
            fetchJournalEntries()
        } catch {
            print("Error deleting journal entry: \(error.localizedDescription)")
        }
    }

    // MARK: - Private Functions
    private func setupInitialJournalEntries() {
        let request: NSFetchRequest<JournalEntity> = JournalEntity.fetchRequest()

        do {
            _ = try viewContext.fetch(request)
            fetchJournalEntries()
        } catch {
            print("Error fetching journal entries: \(error.localizedDescription)")
        }
    }

    private func fetchEntity(for model: JournalModel) -> JournalEntity? {
        let request: NSFetchRequest<JournalEntity> = JournalEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", model.id as CVarArg)

        do {
            return try viewContext.fetch(request).first
        } catch {
            print("Error fetching entity: \(error.localizedDescription)")
            return nil
        }
    }

}
