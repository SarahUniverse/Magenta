//
//  Colors.swift
//  Magenta
//
//  Created by Sarah Clark on 1/15/25.
//

import SwiftUI

struct Colors {
    let colorScheme: ColorScheme

    init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }

    var textColor: Color {
        return colorScheme == .dark ? .white : .black
    }

}
