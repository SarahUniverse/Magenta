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
    @State private var showingAddEntrySheet = false
    @State private var entryTitle = ""
    @State private var entryContent = ""

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
                            .font(.body)
                            .lineLimit(2)
                    }
                }
            }
            .onDelete(perform: deleteEntries)
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
                    .italic()
                    .font(.caption)
                #endif
                journalEntryList
            }
            .navigationTitle("Journal")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .navigationBarItems(trailing:
                                    Button(action: { showingAddEntrySheet = true }) {
                Image(systemName: "plus")
            }
            )
        }
        .sheet(isPresented: $showingAddEntrySheet) {
            NavigationView {
                Form {
                    Section(header: Text("Entry Details")) {
                        TextField("Title", text: $entryTitle)
                        TextEditor(text: $entryContent)
                            .frame(height: 200)
                    }
                }
                .navigationTitle("New Journal Entry")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingAddEntrySheet = false
                    },
                    trailing: Button("Save") {
                        saveEntry()
                    }
                )
            }
        }
        .onAppear {
            journalViewModel.fetchJournalEntries()
        }
    }

    // MARK: - Private Functions
    private func saveEntry() {
        guard !entryTitle.isEmpty, !entryContent.isEmpty else {
            return
        }

        let newEntity = JournalEntity(context: journalViewModel.viewContext)
        newEntity.id = UUID()
        newEntity.title = entryTitle
        newEntity.date = Date()
        newEntity.content = entryContent

        do {
            try journalViewModel.viewContext.save()
            journalViewModel.fetchJournalEntries()
            showingAddEntrySheet = false
            entryTitle = ""
            entryContent = ""
        } catch {
            print("Error saving journal entry: \(error)")
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = journalViewModel.journalEntries[index]
            journalViewModel.deleteJournalEntry(entry)
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

        let context = container.viewContext

        let entry1 = JournalEntity(context: context)
        entry1.id = UUID()
        entry1.title = "First Day of Summer"
        entry1.date = Date().addingTimeInterval(-86400) // Yesterday
        entry1.content = "Today was the first day of summer vacation. I spent the morning at the beach, feeling the warm sun and listening to the waves. It was incredibly relaxing and reminded me why I love this time of year."

        let entry2 = JournalEntity(context: context)
        entry2.id = UUID()
        entry2.title = "Thoughts on Personal Growth"
        entry2.date = Date().addingTimeInterval(-172800) // Two days ago
        entry2.content = "I've been reflecting on my personal growth journey. It's amazing how much I've learned about myself in the past year. Challenges have become opportunities, and I'm grateful for every experience that has shaped me."

        let entry3 = JournalEntity(context: context)
        entry3.id = UUID()
        entry3.title = "Weekend Adventure"
        entry3.date = Date().addingTimeInterval(-259200) // Three days ago
        entry3.content = "Went on an unexpected hiking trip with friends. The trail was challenging, but the view from the top was breathtaking. It reminded me that sometimes the best experiences come from spontaneous decisions."

        do {
            try context.save()
        } catch {
            print("Error saving sample entries: \(error)")
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

        let context = container.viewContext

        let entry1 = JournalEntity(context: context)
        entry1.id = UUID()
        entry1.title = "First Day of Summer"
        entry1.date = Date().addingTimeInterval(-86400) // Yesterday
        entry1.content = "Today was the first day of summer vacation. I spent the morning at the beach, feeling the warm sun and listening to the waves. It was incredibly relaxing and reminded me why I love this time of year."

        let entry2 = JournalEntity(context: context)
        entry2.id = UUID()
        entry2.title = "Thoughts on Personal Growth"
        entry2.date = Date().addingTimeInterval(-172800) // Two days ago
        entry2.content = "I've been reflecting on my personal growth journey. It's amazing how much I've learned about myself in the past year. Challenges have become opportunities, and I'm grateful for every experience that has shaped me."

        let entry3 = JournalEntity(context: context)
        entry3.id = UUID()
        entry3.title = "Weekend Adventure"
        entry3.date = Date().addingTimeInterval(-259200) // Three days ago
        entry3.content = "Went on an unexpected hiking trip with friends. The trail was challenging, but the view from the top was breathtaking. It reminded me that sometimes the best experiences come from spontaneous decisions."

        do {
            try context.save()
        } catch {
            print("Error saving sample entries: \(error)")
        }

        return container
    }()

    return JournalView(viewContext: persistentContainer.viewContext)
        .preferredColorScheme(.dark)
}
