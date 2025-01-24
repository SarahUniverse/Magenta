//
//  BooksViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData

final class BooksViewModel: ObservableObject {
    @Published var books: [BookModel] = []

    func addBook(_ book: BookModel) {
        books.append(book)
    }

    func removeBook(_ book: BookModel) {
        books.removeAll { $0.id == book.id }
    }

}
