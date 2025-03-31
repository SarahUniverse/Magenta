//
//  QuotesViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData
import Foundation
import SwiftUI

@Observable final class QuotesViewModel {
    var quotes: [QuotesModel] = []
    var quotesEntity: [QuoteEntity] = []
    var favoriteQuotes: Set<String> = Set(UserDefaults.standard.stringArray(forKey: "FavoriteQuotes") ?? [])
    var searchText: String = ""
    var selectedSubject: String?

    let subjects = ["love", "grief", "motivation", "friendship", "anger"]
    let viewContext: NSManagedObjectContext
    private var hasLoadedInitialData: Bool = false

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        checkAndLoadInitialData()
        fetchAllQuotes() // Fetch all quotes initially to ensure all favorites are loaded
        syncFavoritesFromCoreData()
    }

    // MARK: Functions
    func fetchAllQuotes() {
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()

        do {
            let fetchedQuotes = try viewContext.fetch(request)
            quotes = fetchedQuotes.map { QuotesModel(quote: $0) }
            syncFavoriteQuotes()
        } catch {
            print("Failed to fetch all quotes: \(error)")
        }
    }

    func fetchQuotes() {
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()

        // Apply filters
        var predicates: [NSPredicate] = []

        // Only apply subject filter if selectedSubject is not nil
        if let subject = selectedSubject {
            if subject == "favorites" {
                predicates.append(NSPredicate(format: "favoriteQuote == YES"))
            } else {
                predicates.append(NSPredicate(format: "quoteSubject == %@", subject))
            }
        }

        if !searchText.isEmpty {
            let contentPredicate = NSPredicate(format: "quoteContent CONTAINS[cd] %@", searchText.lowercased())
            let authorPredicate = NSPredicate(format: "quoteAuthor CONTAINS[cd] %@", searchText.lowercased())
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: [contentPredicate, authorPredicate]))
        }

        request.predicate = predicates.isEmpty ? nil : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        do {
            let fetchedQuotes = try viewContext.fetch(request)
            quotes = fetchedQuotes.map { QuotesModel(quote: $0) }
            syncFavoriteQuotes() // Sync favorites after fetching, even if filtered
        } catch {
            print("Failed to fetch quotes: \(error)")
        }
    }

    func addQuote(content: String, author: String, subject: String) {
        let newQuote = QuoteEntity(context: viewContext)
        newQuote.id = UUID()
        newQuote.quoteContent = content
        newQuote.quoteAuthor = author
        newQuote.quoteSubject = subject
        newQuote.favoriteQuote = false

        do {
            try viewContext.save()
            fetchAllQuotes() // Refresh with all quotes to ensure new quote is visible
        } catch {
            print("Failed to save quote: \(error)")
        }
    }

    func toggleFavorite(quoteId: String) {
        if let index = quotes.firstIndex(where: { $0.id.uuidString == quoteId }) {
            let isNowFavorite = !quotes[index].favoriteQuote
            quotes[index].favoriteQuote = isNowFavorite

            // Update favoriteQuotes without filtering by current quotes
            if isNowFavorite {
                favoriteQuotes.insert(quoteId)
            } else {
                favoriteQuotes.remove(quoteId)
            }

            UserDefaults.standard.set(Array(favoriteQuotes), forKey: "FavoriteQuotes")

            updateFavoriteInCoreData(quoteId: quoteId, isFavorite: isNowFavorite)
        }
    }

    func fetchMostRecentFavoriteQuote() {
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "favoriteQuote == YES")

        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]

        do {
            let fetchedQuotes = try viewContext.fetch(request)
            quotesEntity = fetchedQuotes
        } catch {
            print("Failed to fetch most recent favorite quote: \(error)")
            quotesEntity = []
        }
    }

    // MARK: Private Functions
    private func checkAndLoadInitialData() {
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()
        do {
            let count = try viewContext.count(for: request)
            if count == 0 && !hasLoadedInitialData {
                loadAndSaveQuotesFromJSON()
                hasLoadedInitialData = true
            }
        } catch {
            print("Error checking Core Data: \(error)")
            // Fallback: Load JSON if there's an error checking Core Data
            loadAndSaveQuotesFromJSON()
            hasLoadedInitialData = true
        }
    }

    private func loadAndSaveQuotesFromJSON() {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decodedQuotes = try? JSONDecoder().decode([QuotesModel].self, from: data) else {
            print("Failed to load or decode quotes.json")
            return
        }

        // Save to Core Data
        for quote in decodedQuotes {
            let newQuote = QuoteEntity(context: viewContext)
            newQuote.id = quote.id
            newQuote.quoteContent = quote.quoteContent
            newQuote.quoteAuthor = quote.quoteAuthor
            newQuote.quoteSubject = quote.quoteSubject
            newQuote.favoriteQuote = quote.favoriteQuote
        }

        do {
            try viewContext.save()
            print("Successfully saved JSON quotes to Core Data")
        } catch {
            print("Failed to save quotes to Core Data: \(error)")
        }
    }


    private func updateFavoriteInCoreData(quoteId: String, isFavorite: Bool) {
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", quoteId as CVarArg)

        do {
            if let quote = try viewContext.fetch(request).first {
                quote.favoriteQuote = isFavorite
                try viewContext.save()
            }
        } catch {
            print("Failed to update favorite status: \(error)")
        }
    }

    private func syncFavoriteQuotes() {
        // Update quotes array with favorite status from favoriteQuotes (UserDefaults)
        quotes = quotes.map { quote in
            var mutableQuote = quote
            mutableQuote.favoriteQuote = favoriteQuotes.contains(quote.id.uuidString)
            return mutableQuote
        }

        // Ensure Core Data reflects UserDefaults
        syncFavoritesToCoreData()
    }

    private func syncFavoritesFromCoreData() {
        // Load favorites from Core Data and update favoriteQuotes
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "favoriteQuote == YES")

        do {
            let favoriteEntities = try viewContext.fetch(request)
            let favoriteIds = favoriteEntities.map { $0.id?.uuidString ?? "" }
            favoriteQuotes = Set(favoriteIds.filter { !$0.isEmpty })
            UserDefaults.standard.set(Array(favoriteQuotes), forKey: "FavoriteQuotes")
        } catch {
            print("Failed to sync favorites from Core Data: \(error)")
        }
    }

    private func syncFavoritesToCoreData() {
        // Ensure all quotes in Core Data have the correct favorite status
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()

        do {
            let allQuotes = try viewContext.fetch(request)
            for quote in allQuotes {
                let quoteId = quote.id?.uuidString ?? ""
                quote.favoriteQuote = favoriteQuotes.contains(quoteId)
            }
            try viewContext.save()
        } catch {
            print("Failed to sync favorites to Core Data: \(error)")
        }
    }

}
