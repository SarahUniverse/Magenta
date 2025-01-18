//
//  JournalView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
#if canImport(JournalingSuggestions)
import JournalingSuggestions
#endif
import SwiftUI

struct JournalView: View {
    @StateObject private var journalViewModel: JournalViewModel

    init(viewContext: NSManagedObjectContext) {
        _journalViewModel = StateObject(wrappedValue: JournalViewModel(viewContext: viewContext))
    }

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .blue.opacity(0.6), location: 0),
            Gradient.Stop(color: .blue.opacity(0.3), location: 0.256),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Private Variables
    private var journalEntryList: some View {
        List {
            ForEach(journalViewModel.journalEntries) { entry in
                Section(header: Text(entry.journalEntryDate, style: .date)) {
                    VStack(alignment: .leading) {
                        Text(entry.journalEntryTitle)
                            .font(.headline)
                        Text(entry.journalEntryContent)
                            .lineLimit(nil)
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                #if canImport(JournalingSuggestions)
                JournalingSuggestionsPicker {
                    Text("Show my personal events")
                } onCompletion: { suggestion in
                    // parse selected suggestion
                }
                #else
                Text("This device doesn't support Journaling Suggestions")

                #endif
                journalEntryList
            }
            .navigationTitle("Journal")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)

        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    return JournalView(viewContext: persistentContainer.viewContext)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    return JournalView(viewContext: persistentContainer.viewContext)
        .preferredColorScheme(.dark)
}
