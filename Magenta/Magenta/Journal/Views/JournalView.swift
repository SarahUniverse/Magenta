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
                VStack(alignment: .leading) {
                    Text(entry.journalEntryTitle)
                        .font(.headline)
                    Text(entry.journalEntryContent)
                        .font(.body)
                        .lineLimit(2)
                }
            }
            .onDelete(perform: deleteEntries)
        }
        .listStyle(PlainListStyle())
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
