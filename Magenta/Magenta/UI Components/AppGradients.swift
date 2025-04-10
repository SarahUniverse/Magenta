//
//  AppStyles.swift
//  Magenta
//
//  Created by Sarah Clark on 4/10/25.
//

import SwiftUI

struct AppGradients {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.4)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let iconGradient = LinearGradient(
        gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.indigo]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

}
