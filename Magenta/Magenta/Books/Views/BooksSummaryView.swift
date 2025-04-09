//
//  BooksSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData
import SwiftUI

struct BooksSummaryView: View {
    @State private var booksViewModel: BooksViewModel
    private var viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _booksViewModel = State(wrappedValue: BooksViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: BooksView(viewContext: viewContext)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("BOOKS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "books.vertical")
                        .foregroundStyle(.brown)
                        .font(.largeTitle)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                            .font(.subheadline)
                            .foregroundStyle(.gray)

                        Button("Review") { }
                            .foregroundStyle(.blue)
                    }
                }
                .padding()
                .background(GlassBackground())
                .cornerRadius(10)
            }
        }
    }

}

// MARK: - Previews
#Preview ("Light Mode") {
    let context = BooksSummaryView.createPreviewContext()
    BooksSummaryView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = BooksSummaryView.createPreviewContext()
    BooksSummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension BooksSummaryView {
    static func createPreviewContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack for preview: \(error)")
            }
        }
        return container.viewContext
    }

}
