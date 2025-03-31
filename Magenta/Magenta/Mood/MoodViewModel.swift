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

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
#if DEBUG
        // clearCoreData() // Uncomment for testing purposes
#endif
        setupInitialData()
        fetchMoods()
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

    // MARK: Private Functions
    private func fetchMoods() {
        let request: NSFetchRequest<MoodEntity> = MoodEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "moodDate", ascending: true)]
        do {
            let entities = try viewContext.fetch(request)
            moods = entities.map { MoodModel(entity: $0) }
        } catch {
            print("Error fetching moods: \(error)")
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
