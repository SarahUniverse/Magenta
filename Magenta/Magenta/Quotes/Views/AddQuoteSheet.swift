//
//  AddQuoteSheet.swift
//  Magenta
//
//  Created by Sarah Clark on 3/12/25.
//

import CoreData
import SwiftUI

struct AddQuoteSheet: View {
    @ObservedObject private var quotesViewModel: QuotesViewModel
    @Environment(\.dismiss) var dismiss

    @State private var content = ""
    @State private var author = ""
    @State private var subject = "love"

    init(quotesViewModel: QuotesViewModel) {
        self.quotesViewModel = quotesViewModel
    }

    let subjects = ["love", "grief", "motivation", "friendship", "anger"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Quote Content", text: $content)
                TextField("Author", text: $author)
                Picker("Subject", selection: $subject) {
                    ForEach(subjects, id: \.self) { subject in
                        Text(subject.capitalized).tag(subject)
                    }
                }
            }
            .navigationTitle("Add New Quote")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        quotesViewModel.addQuote(content: content, author: author, subject: subject)
                        dismiss()
                    }
                }
            }
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let container = NSPersistentContainer(name: "QuotesDataModel") // Replace with your model name
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") // In-memory store
    container.loadPersistentStores { _, error in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    let context = container.viewContext
    let viewModel = QuotesViewModel(viewContext: context)

    return AddQuoteSheet(quotesViewModel: viewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = NSPersistentContainer(name: "QuotesDataModel") // Replace with your model name
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") // In-memory store
    container.loadPersistentStores { _, error in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    let context = container.viewContext
    let viewModel = QuotesViewModel(viewContext: context)

    return AddQuoteSheet(quotesViewModel: viewModel)
        .preferredColorScheme(.dark)
}
