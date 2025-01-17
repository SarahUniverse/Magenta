//
//  DiscoverItem.swift
//  Magenta
//
//  Created by Sarah Clark on 1/14/25.
//

import SwiftUI

struct DiscoverItemModel: Identifiable {
    let id = UUID()
    let icon: Image
    let title: String

    init(icon: Image, title: String) {
        self.icon = icon
        self.title = title
    }

    init(title: String) {
        self.icon = Image(systemName: "questionmark")
        self.title = title
    }
}
