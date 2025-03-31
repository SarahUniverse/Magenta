//
//  MoodViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/8/25.
//

import CoreData
import Foundation

@Observable final class MoodViewModel {
    var moods: [MoodModel] = []
    var items: [String] = []
    let viewContext: NSManagedObjectContext
    var moodsEntity: [MoodEntity] = []

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
#if DEBUG
        // clearCoreData() // Uncomment for testing purposes
#endif
        setupInitialData()
        fetchWeekOfMoods()
        fetchMoodsFromCoreData()
    }

    func removeMoodForToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if let moodToRemove = moods.first(where: { calendar.isDate($0.moodDate, inSameDayAs: today) }) {
            let fetchRequest: NSFetchRequest<MoodEntity> = MoodEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", moodToRemove.id as CVarArg)
            do {
                let results = try viewContext.fetch(fetchRequest)
                if let entityToDelete = results.first {
                    viewContext.delete(entityToDelete)
                    try viewContext.save()
                    moods.removeAll { $0.id == moodToRemove.id }
                    print("Mood removed for today")
                    return true
                }
            } catch {
                print("Failed to remove mood: \(error)")
            }
        }
        return false
    }

    func saveMoodToCoreData(mood: String, emoji: String) -> Bool {
        guard !hasMoodForToday() else {
            print("Mood already logged for today")
            return false
        }

        let newMood = MoodEntity(context: viewContext)
        newMood.id = UUID()
        newMood.mood = mood
        newMood.moodEmoji = emoji
        newMood.moodDate = Date()
        newMood.moodValue = moodValue(for: mood)

        do {
            try viewContext.save()
            moods.append(MoodModel(entity: newMood))
            print("Mood saved: \(mood)")
            return true
        } catch {
            print("Failed to save mood: \(error)")
            return false
        }
    }

    func hasMoodForToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return moods.contains { mood in
            if let moodDate = calendar.startOfDay(for: mood.moodDate) as Date? {
                return calendar.isDate(moodDate, inSameDayAs: today)
            }
            return false
        }
    }

    func getTodayMood() -> String? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return moods.first(where: { calendar.isDate($0.moodDate, inSameDayAs: today) })?.mood
    }

    func fetchWeekOfMoods() {
        let request: NSFetchRequest<MoodEntity> = MoodEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MoodEntity.moodDate, ascending: true)]

        // Fetch moods for the last 7 days
        if let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date()) {
            request.predicate = NSPredicate(format: "moodDate >= %@", sevenDaysAgo as NSDate)
        }

        do {
            moodsEntity = try viewContext.fetch(request)
        } catch {
            print("Error fetching moods: \(error)")
            moodsEntity = []
        }
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

    func fetchMoodsFromCoreData() {
        let request: NSFetchRequest<MoodEntity> = MoodEntity.fetchRequest()
        do {
            let entities = try viewContext.fetch(request)
            moods = entities.map { MoodModel(entity: $0) }
        } catch {
            print("Error fetching moods from Core Data: \(error)")
        }
    }

    private func setupInitialData() {
        items = [
            "Excited",
            "Happy",
            "Calm",
            "Curious",
            "Relieved",
            "Loved",
            "Dread",
            "Vulnerable",
            "Surprised",
            "Neutral",
            "Tired",
            "Stressed",
            "Sad",
            "Anxious",
            "Worry",
            "Grief",
            "Fear",
            "Heartbreak",
            "Lonely",
            "Angry"
        ]
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

#if DEBUG
extension MoodViewModel {
    func clearCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MoodEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(batchDeleteRequest)
            try viewContext.save()
            moods.removeAll()
            print("Core Data cleared successfully")
        } catch {
            print("Failed to clear Core Data: \(error)")
        }
    }
}
#endif
