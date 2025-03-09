//
//  MoodSummaryViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData

final class MoodSummaryViewModel: ObservableObject {
    @Published var moods: [MoodEntity] = []
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchMoods()
    }

    func fetchMoods() {
        let request: NSFetchRequest<MoodEntity> = MoodEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MoodEntity.moodDate, ascending: true)]

        // Fetch moods for the last 5 days
        if let fiveDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: Date()) {
            request.predicate = NSPredicate(format: "moodDate >= %@", fiveDaysAgo as NSDate)
        }

        do {
            moods = try viewContext.fetch(request)
        } catch {
            print("Error fetching moods: \(error)")
            moods = []
        }
    }

    func refreshChart() {
        fetchMoods()
    }

}
