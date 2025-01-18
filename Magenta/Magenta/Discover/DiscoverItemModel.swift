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
    let iconColors: [Color]

    init(icon: Image, title: String, iconColor: Color) {
        self.icon = icon
        self.title = title
        self.iconColors = [iconColor]
    }

    init(icon: Image, title: String, iconColors: [Color]) {
        self.icon = icon
        self.title = title
        self.iconColors = iconColors
    }
}
