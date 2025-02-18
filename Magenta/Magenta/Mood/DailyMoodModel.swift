//
//  DailyMoodModel.swift
//  Magenta
//
//  Created by Sarah Clark on 2/17/25.
//

import Foundation

struct DailyMoodModel: Identifiable {
    let id = UUID()
    let date: Date
    let mood: String
    let moodValue: Double
}
