//
//  Item.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
