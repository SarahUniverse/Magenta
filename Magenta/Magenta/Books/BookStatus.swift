//
//  BookStatus.swift
//  Magenta
//
//  Created by Sarah Clark on 1/25/25.
//

import Foundation

enum BookStatus: String, CaseIterable, Identifiable {
    case wantToRead = "Want to Read"
    case currentlyReading = "Currently Reading"
    case finishedReading = "Finished Reading"

    var id: String {
        self.rawValue
    }

    var systemImage: String {
        switch self {
        case .wantToRead:
            return "bookmark"
        case .currentlyReading:
            return "book.fill"
        case .finishedReading:
            return "checkmark.circle.fill"
        }
    }

}
