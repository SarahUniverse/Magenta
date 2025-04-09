//
//  BooksViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData

@Observable final class BooksViewModel {
    var books: [BookModel] = []
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchBooks()
    }

    func addBook(_ book: BookModel) {
        let newBookEntity = BookEntity(context: viewContext)
        newBookEntity.id = book.id
        newBookEntity.title = book.bookTitle
        newBookEntity.author = book.bookAuthor
        newBookEntity.bookDescription = book.bookDescription
        newBookEntity.bookPublisher = book.bookPublisher
        newBookEntity.bookEdition = book.bookEdition

        // Save status as a string
        newBookEntity.status = book.status.rawValue

        do {
            try viewContext.save()
            fetchBooks()
        } catch {
            print("Error saving book: \(error)")
        }
    }

    func updateBookStatus(_ book: BookModel, to newStatus: BookStatus) {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.id as CVarArg)

        do {
            let results = try viewContext.fetch(fetchRequest)
            if let bookEntity = results.first {
                // Update the status
                bookEntity.status = newStatus.rawValue
                try viewContext.save()
                fetchBooks()
            }
        } catch {
            print("Error updating book status: \(error)")
        }
    }

    func removeBook(_ book: BookModel) {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.id as CVarArg)

        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                viewContext.delete(object)
            }
            try viewContext.save()
            fetchBooks()
        } catch {
            print("Error deleting book: \(error)")
        }
    }

    // MARK: - Private Functions
    private func fetchBooks() {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()

        do {
            let entities = try viewContext.fetch(request)
            books = entities.map { BookModel(entity: $0)}
        } catch {
            print("Error fetching books: \(error.localizedDescription)")
        }
    }

}

extension BooksViewModel {
    func fetchBooksByStatus(_ status: BookStatus) -> [BookModel] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "status == %@", status.rawValue)

        do {
            let entities = try viewContext.fetch(request)
            return entities.map { BookModel(entity: $0) }
        } catch {
            print("Error fetching books by status: \(error)")
            return []
        }
    }

}
