//
//  MoodChartViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 2/17/25.
//

import Charts
import CoreData
import Foundation
import SwiftUI

final class MoodChartViewModel: ObservableObject {
    @Published var dailyMoods: [MoodModel] = []
    @StateObject private var moodViewModel: MoodViewModel

    init(viewContext: NSManagedObjectContext) {
        _moodViewModel = StateObject(wrappedValue: MoodViewModel(viewContext: viewContext))
        loadMoodData()
    }

    func refreshChart() {
        loadMoodData()
    }

    private func loadMoodData() {
        dailyMoods = moodViewModel.moods
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
