//
//  QuotesViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData
import Foundation

class QuotesViewModel: ObservableObject {
    @Published var quotes: [QuotesModel] = []
    @Published var favoriteQuotes: Set<String> = Set(UserDefaults.standard.stringArray(forKey: "FavoriteQuotes") ?? [])
    @Published var searchText: String = ""
    @Published var selectedSubject: String?

    let subjects = ["love", "grief", "motivation", "friendship", "anger"]
    private let container: NSPersistentContainer
    private var hasLoadedInitialJSONData: Bool = false

    init() {
        container = PersistenceController.shared.persistentContainer
        checkAndLoadInitialData()
        fetchQuotes()
    }

    private func checkAndLoadInitialData() {
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()
        do {
            let count = try container.viewContext.count(for: request)
            if count == 0 && !hasLoadedInitialJSONData {
                loadAndSaveQuotesFromJSON()
                hasLoadedInitialJSONData = true
            }
        } catch {
            print("Error checking Core Data: \(error)")
            loadAndSaveQuotesFromJSON()
            hasLoadedInitialJSONData = true
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
            let newQuote = QuoteEntity(context: container.viewContext)
            newQuote.id = quote.id
            newQuote.quoteContent = quote.quoteContent
            newQuote.quoteAuthor = quote.quoteAuthor
            newQuote.quoteSubject = quote.quoteSubject
            newQuote.favoriteQuote = quote.favoriteQuote
        }

        do {
            try container.viewContext.save()
            print("Successfully saved JSON quotes to Core Data")
        } catch {
            print("Failed to save quotes to Core Data: \(error)")
        }
    }

    func fetchQuotes() {
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()

        // Apply filters
        var predicates: [NSPredicate] = []

        if let subject = selectedSubject {
            predicates.append(NSPredicate(format: "quoteSubject == %@", subject))
        }

        if !searchText.isEmpty {
            let contentPredicate = NSPredicate(format: "quoteContent CONTAINS[cd] %@", searchText.lowercased())
            let authorPredicate = NSPredicate(format: "quoteAuthor CONTAINS[cd] %@", searchText.lowercased())
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: [contentPredicate, authorPredicate]))
        }

        request.predicate = predicates.isEmpty ? nil : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        do {
            let fetchedQuotes = try container.viewContext.fetch(request)
            quotes = fetchedQuotes.map { QuotesModel(quote: $0) }
            syncFavoriteQuotes()
        } catch {
            print("Failed to fetch quotes: \(error)")
        }
    }

    func addQuote(content: String, author: String, subject: String) {
        let newQuote = QuoteEntity(context: container.viewContext)
        newQuote.id = UUID()
        newQuote.quoteContent = content
        newQuote.quoteAuthor = author
        newQuote.quoteSubject = subject
        newQuote.favoriteQuote = false

        do {
            try container.viewContext.save()
            fetchQuotes() // Refresh the list
        } catch {
            print("Failed to save quote: \(error)")
        }
    }

    func toggleFavorite(quoteId: String) {
        if let index = quotes.firstIndex(where: { $0.id.uuidString == quoteId }) {
            quotes[index].favoriteQuote.toggle()
            favoriteQuotes = Set(quotes.filter { $0.favoriteQuote }.map { $0.id.uuidString })
            UserDefaults.standard.set(Array(favoriteQuotes), forKey: "FavoriteQuotes")

            // Update Core Data
            updateFavoriteInCoreData(quoteId: quoteId, isFavorite: quotes[index].favoriteQuote)
        }
    }

    private func updateFavoriteInCoreData(quoteId: String, isFavorite: Bool) {
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", quoteId as CVarArg)

        do {
            if let quote = try container.viewContext.fetch(request).first {
                quote.favoriteQuote = isFavorite
                try container.viewContext.save()
            }
        } catch {
            print("Failed to update favorite status: \(error)")
        }
    }

    private func syncFavoriteQuotes() {
        quotes = quotes.map { quote in
            var mutableQuote = quote
            mutableQuote.favoriteQuote = favoriteQuotes.contains(quote.id.uuidString)
            return mutableQuote
        }
    }

}
