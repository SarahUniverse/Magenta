//
//  QuotesModel.swift
//  Magenta
//
//  Created by Sarah Clark on 3/10/25.
//

import SwiftUI

struct QuotesModel: Identifiable, Codable {
    let id: UUID
    let quoteContent: String
    let quoteAuthor: String
    let quoteSubject: String
    var favoriteQuote: Bool

    init(quote: QuoteEntity) {
        self.id = quote.id ?? UUID()
        self.quoteContent = quote.quoteContent ?? ""
        self.quoteAuthor = quote.quoteAuthor ?? ""
        self.quoteSubject = quote.quoteSubject ?? ""
        self.favoriteQuote = quote.favoriteQuote
    }

    enum CodingKeys: String, CodingKey {
        case id
        case quoteContent = "content"
        case quoteAuthor = "author"
        case quoteSubject = "subject"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        if let uuid = UUID(uuidString: idString) {
            self.id = uuid
        } else {
            self.id = UUID()
        }
        self.quoteContent = try container.decode(String.self, forKey: .quoteContent)
        self.quoteAuthor = try container.decode(String.self, forKey: .quoteAuthor)
        self.quoteSubject = try container.decode(String.self, forKey: .quoteSubject)
        self.favoriteQuote = false
    }

}
