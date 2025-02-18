//
//  MoodChartViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 2/17/25.
//

import Charts
import Foundation

final class MoodChartViewModel: ObservableObject {
    @Published var dailyMoods: [DailyMoodModel] = []

    init() {
        loadMoodData()
    }

    private func loadMoodData() {
        // Sample data - replace with your actual data source
        let lastWeek = [
            DailyMoodModel(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, mood: "Happy", moodValue: 4.0),
            DailyMoodModel(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, mood: "Excited", moodValue: 5.0),
            DailyMoodModel(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, mood: "Neutral", moodValue: 3.0),
            DailyMoodModel(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, mood: "Sad", moodValue: 2.0),
            DailyMoodModel(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, mood: "Happy", moodValue: 4.0),
            DailyMoodModel(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, mood: "Calm", moodValue: 3.5),
            DailyMoodModel(date: Date(), mood: "Excited", moodValue: 5.0)
        ]

        dailyMoods = lastWeek
    }

    // Helper function to get mood label for y-axis
    func getMoodLabel(for value: Double) -> String {
    switch value {
        case 5.0: return "Excited"
        case 4.0: return "Happy"
        case 3.5: return "Calm"
        case 3.0: return "Neutral"
        case 2.5: return "Tired"
        case 2.0: return "Sad"
        case 1.5: return "Anxious"
        case 1.0: return "Angry"
        case 0.5: return "Heavy Grief"
        default: return ""
        }
    }
}
