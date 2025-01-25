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
    var status: BookStatus

    init(entity: BookEntity) {
        self.id = entity.id ?? UUID()
        self.bookTitle = entity.title ?? ""
        self.bookAuthor = entity.author ?? ""
        self.bookDescription = entity.bookDescription ?? ""
        self.bookPublisher = entity.bookPublisher ?? ""
        self.bookEdition = entity.bookEdition ?? ""

        if let statusString = entity.status, let bookStatus = BookStatus(rawValue: statusString) {
            self.status = bookStatus
        } else {
            fatalError("Invalid or missing book status")
        }
    }

    init(id: UUID, bookTitle: String, bookAuthor: String, bookDescription: String, bookPublisher: String, bookEdition: String, status: BookStatus) {
        self.id = id
        self.bookTitle = bookTitle
        self.bookAuthor = bookAuthor
        self.bookDescription = bookDescription
        self.bookPublisher = bookPublisher
        self.bookEdition = bookEdition
        self.status = status
    }
}
