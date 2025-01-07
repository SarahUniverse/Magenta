//
//  SummaryViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/7/25.
//

import SwiftUI

final class SummaryViewModel: ObservableObject {
    // TODO: Update this code a lot.
    // Add any properties or methods needed for the view model
    // For example, you might want to track user data or summary statistics

    // Example property
    @Published var exerciseSummary: String = "No exercise data available."
    @Published var sleepSummary: String = "No sleep data available."
    @Published var nutritionSummary: String = "No nutrition data available."
    @Published var meditationSummary: String = "No meditation data available."

    init() {
        // Initialize or fetch data here
        fetchSummaryData()
    }

    private func fetchSummaryData() {
        // Simulate fetching data
        exerciseSummary = "You exercised for 30 minutes today."
        sleepSummary = "You slept for 7 hours last night."
        nutritionSummary = "You consumed 2000 calories today."
        meditationSummary = "You meditated for 15 minutes today."
    }
}
