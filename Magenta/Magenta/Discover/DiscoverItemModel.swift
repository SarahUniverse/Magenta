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
    let iconColor: LinearGradient

    init(icon: Image, title: String, iconColor: LinearGradient) {
        self.icon = icon
        self.title = title
        self.iconColor = iconColor
    }

}
