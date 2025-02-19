//
//  MoodChartViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 2/17/25.
//

import Charts
import Foundation

final class MoodChartViewModel: ObservableObject {
    @Published var dailyMoods: [MoodModel] = []

    init() {
        loadMoodData()
    }

    private func loadMoodData() {
        // Sample data - replace with your actual data source
        let lastWeek = [
        MoodModel(id: UUID(), mood: "Happy", moodDate: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, moodValue: 9.0, moodEmoji: "😊"),
        MoodModel(id: UUID(), mood: "Excited", moodDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, moodValue: 10.0, moodEmoji: "🤩"),
        MoodModel(id: UUID(), mood: "Neutral", moodDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, moodValue: 6.0, moodEmoji: "😐"),
        MoodModel(id: UUID(), mood: "Sad", moodDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, moodValue: 2.5, moodEmoji: "😢"),
        MoodModel(id: UUID(), mood: "Happy", moodDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, moodValue: 9.0, moodEmoji: "😊"),
        MoodModel(id: UUID(), mood: "Calm", moodDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, moodValue: 7.5, moodEmoji: "😌"),
        MoodModel(id: UUID(), mood: "Excited", moodDate: Date(), moodValue: 10.0, moodEmoji: "🤩")
        ]

        dailyMoods = lastWeek
    }

    func getMoodLabel(for value: Double) -> String {
        switch value {
        case 10.0: return "Excited"
        case 9.0: return "Happy"
        case 8.5: return "Loved"
        case 8.0: return "Relieved"
        case 7.5: return "Calm"
        case 7.0: return "Curious"
        case 6.5: return "Surprised"
        case 5.0: return "Neutral"
        case 4.7: return "Tired"
        case 4.5: return "Vulnerable"
        case 4.0: return "Stressed"
        case 3.5: return "Anxious"
        case 3.0: return "Worry"
        case 2.5: return "Sad"
        case 2.0: return "Dread"
        case 1.8: return "Fear"
        case 1.5: return "Grief"
        case 1.3: return "Lonely"
        case 1.2: return "Angry"
        case 1.0: return "Heartbreak"
        default: return "Unknown"
        }
    }

}
