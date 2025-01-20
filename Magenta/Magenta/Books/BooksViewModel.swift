//
//  BooksViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData

final class BooksViewModel: ObservableObject {
    @Published var books: [BookModel] = []
}
