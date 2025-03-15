//
//  QuotesSummaryViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData

final class QuotesSummaryViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext
    @Published var quotes: [QuoteEntity] = []

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchMostRecentFavoriteQuote()
    }

    func fetchMostRecentFavoriteQuote() {
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "favoriteQuote == YES")

        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]

        do {
            let fetchedQuotes = try viewContext.fetch(request)
            quotes = fetchedQuotes
        } catch {
            print("Failed to fetch most recent favorite quote: \(error)")
            quotes = []
        }

    }

}
