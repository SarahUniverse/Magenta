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
    @Published var selectedSubject: String? = nil

    let subjects = ["love", "grief", "motivation", "friendship", "anger"]
    private var allQuotes: [QuotesModel] = []

    init() {
        loadQuotesFromJSON()
    }

    func loadQuotesFromJSON() {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decodedQuotes = try? JSONDecoder().decode([QuotesModel].self, from: data) else {
            print("Failed to load or decode quotes.json")
            return
        }
        quotes = decodedQuotes
        syncFavoriteQuotes()
        filterQuotes()
    }

    func fetchQuotes() {
        filterQuotes()
    }

    func toggleFavorite(quoteId: String) {
        if favoriteQuotes.contains(quoteId) {
            favoriteQuotes.remove(quoteId)
        } else {
            favoriteQuotes.insert(quoteId)
        }

        UserDefaults.standard.set(Array(favoriteQuotes), forKey: "FavoriteQuotes")

        if let index = quotes.firstIndex(where: { $0.id == quoteId }) {
            quotes[index].favoriteQuote.toggle()
        }

        if let allIndex = allQuotes.firstIndex(where: { $0.id == quoteId }) {
            allQuotes[allIndex].favoriteQuote = favoriteQuotes.contains(quoteId)
        }

    }

    // MARK: - Private Functions
    private func filterQuotes() {
        var filteredQuotes = allQuotes

        // Filter by subject if one is selected
        if let subject = selectedSubject {
            filteredQuotes = filteredQuotes.filter { $0.quoteSubject == subject }
        }

        // Filter by search text if provided
        if !searchText.isEmpty {
            filteredQuotes = filteredQuotes.filter {
                $0.quoteContent.lowercased().contains(searchText.lowercased()) ||
                $0.quoteAuthor.lowercased().contains(searchText.lowercased())
            }
        }

            self.quotes = filteredQuotes
    }

    private func syncFavoriteQuotes() {
        allQuotes = quotes.map { quote in
            var mutableQuote = quote
            mutableQuote.favoriteQuote = favoriteQuotes.contains(quote.id)
            return mutableQuote
        }
        quotes = allQuotes
    }

}
