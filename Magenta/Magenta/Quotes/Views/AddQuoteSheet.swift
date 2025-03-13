//
//  AddQuoteSheet.swift
//  Magenta
//
//  Created by Sarah Clark on 3/12/25.
//

import CoreData
import SwiftUI

struct AddQuoteSheet: View {
    @ObservedObject var viewModel: QuotesViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss

    @State private var content = ""
    @State private var author = ""
    @State private var subject = "love"

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
                        viewModel.addQuote(content: content, author: author, subject: subject)
                        dismiss()
                    }
                }
            }
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    QuotesView()
        .preferredColorScheme(.light)
        .environment(\.managedObjectContext, PreviewPersistenceController.preview.container.viewContext)
}

#Preview("Dark Mode") {
    QuotesView()
        .preferredColorScheme(.dark)
        .environment(\.managedObjectContext, PreviewPersistenceController.preview.container.viewContext)
}
