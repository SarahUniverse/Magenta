//
//  MoodModel.swift
//  Magenta
//
//  Created by Sarah Clark on 2/17/25.
//

import CoreData
import Foundation

struct MoodModel: Identifiable, Equatable {
    let id: UUID
    let mood: String
    let moodDate: Date
    let moodValue: Double
    let moodEmoji: String

    init(entity: MoodEntity) {
        self.id = entity.id ?? UUID()
        self.mood = entity.mood ?? ""
        self.moodDate = entity.moodDate ?? Date()
        self.moodValue = entity.moodValue
        self.moodEmoji = entity.moodEmoji ?? ""
    }

    init(id: UUID, mood: String, moodDate: Date, moodValue: Double, moodEmoji: String) {
        self.id = id
        self.mood = mood
        self.moodDate = moodDate
        self.moodValue = moodValue
        self.moodEmoji = moodEmoji
    }

}
