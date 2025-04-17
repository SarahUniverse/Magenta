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

    static let discoverIconGradient = LinearGradient(
        gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.indigo]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let summaryIconGradient = LinearGradient(
        gradient: Gradient(colors: [.blue1, Color.purple.opacity(0.6), Color.indigo]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let summaryTitleTextGradient = LinearGradient(
        gradient: Gradient(colors: [.blue2, .blue1]),
        startPoint: .topTrailing,
        endPoint: .bottomLeading
    )

    // NutritionView specific gradients
    static let waterIntakeGradient = Gradient(colors: [.white, .mediumBlue, .darkBlue])

    static let calorieIntakeGradient = Gradient(colors: [.white, .orange, .red])

    static let proteinIntakeGradient = Gradient(colors: [.white, .yellow, .brown])

}
