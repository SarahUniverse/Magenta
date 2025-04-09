//
//  BookRowView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/25/25.
//

import CoreData
import SwiftUI

struct BookRowView: View {
    let book: BookModel
    @State private var booksViewModel: BooksViewModel
    private let viewContext: NSManagedObjectContext

    init(book: BookModel, viewContext: NSManagedObjectContext) {
        self.book = book
        self.viewContext = viewContext
        _booksViewModel = State(wrappedValue: BooksViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                bookTitleAndEditionView
                bookAuthorView
                bookDescriptionView
                bookStatusAndActionView
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Private Variables
    private var bookTitleAndEditionView: some View {
        HStack {
            Text(book.bookTitle)
                .font(.headline)
            Text(book.bookEdition + " Edition")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var bookAuthorView: some View {
        Text("by \(book.bookAuthor)")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    private var bookDescriptionView: some View {
        Text(book.bookDescription)
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    private var bookStatusAndActionView: some View {
        HStack {
            changeStatusMenu
            Spacer()
            statusIcon
        }
    }

    private var changeStatusMenu: some View {
        Menu {
            ForEach(BookStatus.allCases.filter { $0 != book.status }) { status in
                Button(action: {
                    updateBookStatus(to: status)
                }, label: {
                    Text("Move to \(status.rawValue)")
                    Image(systemName: status.systemImage)
                })
            }
        } label: {
            HStack {
                Text("Change Status")
                Image(systemName: "ellipsis.circle")
            }
            .font(.caption)
            .foregroundStyle(.blue)
        }
    }

    private var statusIcon: some View {
        Image(systemName: book.status.systemImage)
            .foregroundStyle(.secondary)
    }

    // MARK: - Private Functions
    private func updateBookStatus(to newStatus: BookStatus) {
        booksViewModel.updateBookStatus(book, to: newStatus)
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let context = BookRowView.createPreviewContext()
    let sampleBook = BookModel(
        id: UUID(),
        bookTitle: "Sample Book",
        bookAuthor: "John Doe",
        bookDescription: "A sample book description",
        bookPublisher: "Sample Publisher",
        bookEdition: "1st",
        status: .wantToRead
    )

    BookRowView(book: sampleBook, viewContext: context)
        .padding(20)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let context = BookRowView.createPreviewContext()

    let sampleBook = BookModel(
        id: UUID(),
        bookTitle: "Sample Book",
        bookAuthor: "John Doe",
        bookDescription: "A sample book description",
        bookPublisher: "Sample Publisher",
        bookEdition: "1st",
        status: .wantToRead
    )

    BookRowView(book: sampleBook, viewContext: context)
        .padding(20)
        .preferredColorScheme(.dark)
}

extension BookRowView {
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
