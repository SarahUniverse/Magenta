//
//  BookStatus.swift
//  Magenta
//
//  Created by Sarah Clark on 1/25/25.
//

import Foundation

enum BookStatus: String, CaseIterable, Identifiable, Hashable {
    case currentlyReading = "Currently Reading"
    case finishedReading = "Finished Reading"
    case wantToRead = "Want to Read"

    var id: String {
        self.rawValue
    }

    var systemImage: String {
        switch self {
            case .currentlyReading:
                return "book.fill"
            case .finishedReading:
                return "checkmark.circle.fill"
            case .wantToRead:
                return "bookmark"
            }
    }

}
