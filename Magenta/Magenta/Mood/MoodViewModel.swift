//
//  MoodViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/8/25.
//

import CoreData
import Foundation

final class MoodViewModel: ObservableObject {
    @Published var moods: [MoodModel] = []
    @Published var items: [String] = []
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchMoodsFromCoreData()
    }

    func saveMoodToCoreData(mood: String, emoji: String) {
        let newMood = MoodEntity(context: viewContext)
        newMood.id = UUID()
        newMood.mood = mood
        newMood.moodEmoji = emoji
        newMood.moodDate = Date()
        newMood.moodValue = moodValue(for: mood)
    }

    // MARK: Private Functions
    private func fetchMoodsFromCoreData() {
        let request: NSFetchRequest<MoodEntity> = MoodEntity.fetchRequest()
        do {
            let entities = try viewContext.fetch(request)
            moods = entities.map { MoodModel (entity: $0)}
        } catch {
            print("Error fetching moods from Core Data: \(error)")
        }
    }

    private func moodValue(for mood: String) -> Double {
        switch mood {
        case "Excited": return 10.0
        case "Happy": return 9.0
        case "Loved": return 8.5
        case "Relieved": return 8.0
        case "Calm": return 7.5
        case "Curious": return 7.0
        case "Surprised": return 6.5
        case "Neutral": return 5.0
        case "Tired": return 4.7
        case "Vulnerable": return 4.5
        case "Stressed": return 4.0
        case "Anxious": return 3.5
        case "Worry": return 3.0
        case "Sad": return 2.5
        case "Dread": return 2.0
        case "Fear": return 1.8
        case "Grief": return 1.5
        case "Lonely": return 1.3
        case "Angry": return 1.2
        case "Heartbreak": return 1.0
        default: return 5.0
        }
    }

}
