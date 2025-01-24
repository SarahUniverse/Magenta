//
//  BookModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData
import Foundation

struct BookModel: Identifiable {
    let id: UUID
    let bookTitle: String
    let bookAuthor: String
    let bookDescription: String
    let bookPublisher: String
    let bookEdition: String

    init(entity: BookEntity) {
        id = entity.id ?? UUID()
        bookTitle = entity.title ?? ""
        bookAuthor = entity.author ?? ""
        bookDescription = entity.bookDescription ?? ""
        bookPublisher = entity.bookPublisher ?? ""
        bookEdition = entity.bookEdition ?? ""
    }

    init(id: UUID, bookTitle: String, bookAuthor: String, bookDescription: String, bookPublisher: String, bookEdition: String) {
        self.id = id
        self.bookTitle = bookTitle
        self.bookAuthor = bookAuthor
        self.bookDescription = bookDescription
        self.bookPublisher = bookPublisher
        self.bookEdition = bookEdition
    }
}
