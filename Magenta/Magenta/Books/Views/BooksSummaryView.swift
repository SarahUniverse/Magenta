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
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .center) {
                        Text("books")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.leading, 5)
                        Image(systemName: "books.vertical")
                            .foregroundStyle(AppGradients.iconGradient)
                            .font(.largeTitle)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                            .font(.subheadline)
                            .foregroundStyle(.gray)

                        Button("Review") { }
                            .foregroundStyle(.blue)
                    }
                    Spacer()
                    NavigationChevron()
                }
                .padding(25)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(GlassBackground())
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
