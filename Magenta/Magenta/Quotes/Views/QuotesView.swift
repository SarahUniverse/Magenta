//
//  QuotesView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct QuotesView: View {
    @StateObject private var quotesViewModel = QuotesViewModel()

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray, location: 0),
            Gradient.Stop(color: .yellow.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .yellow.opacity(0.7), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                subjectFilter
                quotesList
            }
            .navigationTitle("Quotes that Move Me")
            .background(backgroundGradient)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
        }
    }

    private var searchBar: some View {
        TextField("Search quotes...", text: $quotesViewModel.searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .submitLabel(.search)
            .onSubmit {
                quotesViewModel.fetchQuotes()
            }
    }

    private var subjectFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(quotesViewModel.subjects, id: \.self) { subject in
                    Button(action: {
                        quotesViewModel.selectedSubject = subject
                        quotesViewModel.fetchQuotes()
                    }, label: {
                        Text(subject.capitalized)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                quotesViewModel.selectedSubject == subject ?
                                Color.yellow.opacity(0.8) : Color.gray.opacity(0.3)
                            )
                            .clipShape(Capsule())
                            .foregroundStyle(.primary)
                    })
                }
            }
            .padding(.horizontal)
        }
    }

    private var quotesList: some View {
        List(quotesViewModel.quotes) { quote in
            VStack(alignment: .leading, spacing: 8) {
                Text(quote.quoteContent)
                    .font(.body)
                Text("— \(quote.quoteAuthor)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack {
                    Spacer()
                    Button(action: {
                        quotesViewModel.toggleFavorite(quoteId: quote.id)
                    }, label: {
                        Image(systemName: quote.favoriteQuote ? "heart.fill" : "heart")
                            .foregroundStyle(.red)
                    })
                }
            }
            .padding(.vertical, 4)
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            quotesViewModel.fetchQuotes()
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    QuotesView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    QuotesView()
        .preferredColorScheme(.dark)
}
