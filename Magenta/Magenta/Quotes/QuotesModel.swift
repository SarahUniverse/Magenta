//
//  QuotesModel.swift
//  Magenta
//
//  Created by Sarah Clark on 3/10/25.
//

import SwiftUI

struct QuotesModel: Identifiable, Codable {
    let id: String
    let quoteContent: String
    let quoteAuthor: String
    let quoteSubject: String
    var favoriteQuote: Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case quoteContent = "content"
        case quoteAuthor = "author"
        case quoteSubject = "subject"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.quoteContent = try container.decode(String.self, forKey: .quoteContent)
        self.quoteAuthor = try container.decode(String.self, forKey: .quoteAuthor)
        self.quoteSubject = try container.decode(String.self, forKey: .quoteSubject)
        self.favoriteQuote = false
    }

}
