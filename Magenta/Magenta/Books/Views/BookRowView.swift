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
    var booksViewModel: BooksViewModel

    // MARK: - Body
    var body: some View {
        Section {
            bookDetailsView
        }
    }

    // MARK: - Private Variables
    private var bookDetailsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            bookTitleAndEditionView
            bookAuthorView
            bookDescriptionView
            bookStatusAndActionView
        }
        .padding(.vertical, 8)
    }

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
