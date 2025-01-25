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
    @ObservedObject var booksViewModel: BooksViewModel

    // MARK: - Main View
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(book.bookTitle)
                        .font(.headline)
                    Text(book.bookEdition + " Edition")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text("by \(book.bookAuthor)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(book.bookDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack {
                    Image(systemName: book.status.systemImage)
                        .foregroundColor(.secondary)

                    Spacer()

                    // Move book between statuses
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
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Private Functions
    private func updateBookStatus(to newStatus: BookStatus) {
        booksViewModel.updateBookStatus(book, to: newStatus)
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

    let viewContext = persistentContainer.viewContext
    let booksViewModel = BooksViewModel(viewContext: viewContext)

    let sampleBooks = [
        BookModel(
            id: UUID(),
            bookTitle: "Sample Book",
            bookAuthor: "John Doe",
            bookDescription: "A sample book description",
            bookPublisher: "Sample Publisher",
            bookEdition: "1st",
            status: .wantToRead
        )
    ]

    sampleBooks.forEach { book in
        let bookEntity = BookEntity(context: viewContext)
        bookEntity.id = book.id
        bookEntity.title = book.bookTitle
        bookEntity.author = book.bookAuthor
        bookEntity.bookDescription = book.bookDescription
        bookEntity.bookPublisher = book.bookPublisher
        bookEntity.bookEdition = book.bookEdition
        bookEntity.status = book.status.rawValue
    }

    do {
        try viewContext.save()
    } catch {
        print("Error saving sample books: \(error)")
    }

    return BookRowView(book: sampleBooks[0], booksViewModel: booksViewModel)
        .padding(20)
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

    let viewContext = persistentContainer.viewContext
    let booksViewModel = BooksViewModel(viewContext: viewContext)

    let sampleBooks = [
        BookModel(
            id: UUID(),
            bookTitle: "Sample Book",
            bookAuthor: "John Doe",
            bookDescription: "A sample book description",
            bookPublisher: "Sample Publisher",
            bookEdition: "1st",
            status: .wantToRead
        )
    ]

    sampleBooks.forEach { book in
        let bookEntity = BookEntity(context: viewContext)
        bookEntity.id = book.id
        bookEntity.title = book.bookTitle
        bookEntity.author = book.bookAuthor
        bookEntity.bookDescription = book.bookDescription
        bookEntity.bookPublisher = book.bookPublisher
        bookEntity.bookEdition = book.bookEdition
        bookEntity.status = book.status.rawValue
    }

    do {
        try viewContext.save()
    } catch {
        print("Error saving sample books: \(error)")
    }

    return BookRowView(book: sampleBooks[0], booksViewModel: booksViewModel)
        .padding(20)
        .preferredColorScheme(.dark)
}
