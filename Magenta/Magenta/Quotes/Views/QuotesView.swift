//
//  QuotesView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import SwiftUI

struct QuotesView: View {
    @State private var quotesViewModel: QuotesViewModel
    @State private var showAddQuoteSheet = false

    init(viewContext: NSManagedObjectContext) {
        _quotesViewModel = State(wrappedValue: QuotesViewModel(viewContext: viewContext))
    }

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray, location: 0),
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
                    .padding(.top, 15)
            }
            .navigationTitle("Quotes that Inspire")
            .background(AppGradients.backgroundGradient)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddQuoteSheet = true
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.white, .indigo)
                            .shadow(radius: 5, y: 3)
                    })

                }
            }
            .sheet(isPresented: $showAddQuoteSheet) {
                AddQuoteSheet(quotesViewModel: quotesViewModel)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)

            TextField("Search", text: $quotesViewModel.searchText)
                .submitLabel(.search)
                .textInputAutocapitalization(.never)
                .onSubmit {
                    quotesViewModel.fetchQuotes()
                }

            if !quotesViewModel.searchText.isEmpty {
                Button(action: {
                    quotesViewModel.searchText = ""
                    quotesViewModel.fetchQuotes()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                })
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
    }

    private var subjectFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // Button to reset to all quotes
                Button(action: {
                    quotesViewModel.selectedSubject = nil
                    quotesViewModel.fetchAllQuotes() // Show all quotes (including favorites)
                }, label: {
                    Text("All")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            quotesViewModel.selectedSubject == nil ?
                            Color.indigo.opacity(0.6) : Color.gray.opacity(0.8)
                        )
                        .clipShape(Capsule())
                        .foregroundStyle(.black.opacity(0.6))
                })

                Button(action: {
                    quotesViewModel.selectedSubject = "favorites"
                    quotesViewModel.fetchQuotes()
                }, label: {
                    Text("Favorites")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            quotesViewModel.selectedSubject == "favorites" ?
                            Color.indigo.opacity(0.6) : Color.gray.opacity(0.8)
                        )
                        .clipShape(Capsule())
                        .foregroundStyle(.black.opacity(0.6))
                })

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
                                Color.indigo.opacity(0.6) : Color.gray.opacity(0.8)
                            )
                            .clipShape(Capsule())
                            .foregroundStyle(.black.opacity(0.6))
                    })
                }

            }
            .padding(.horizontal)
        }
    }

    private var quotesList: some View {
        Group {
            if quotesViewModel.quotes.isEmpty && quotesViewModel.selectedSubject == "favorites" {
                ContentUnavailableView(
                    "No Favorite Quotes",
                    systemImage: "heart.slash",
                    description: Text("Tap the heart icon on any quote to mark it as a favorite.").bold()
                )
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
            } else {
                List(quotesViewModel.quotes, id: \.id) { quote in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(quote.quoteContent)
                            .font(.body)
                        Text("— \(quote.quoteAuthor)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    quotesViewModel.toggleFavorite(quoteId: quote.id.uuidString)
                                }
                            }, label: {
                                Image(systemName: quote.favoriteQuote ? "heart.fill" : "heart")
                                    .foregroundStyle(.indigo)
                                    .rotationEffect(.degrees(quote.favoriteQuote ? 360 : 0))
                            })
                        }
                    }
                    .padding(.vertical, 4)
                }
                .id(quotesViewModel.selectedSubject ?? "all")
                .scrollContentBackground(.hidden)
            }
        }
        .onAppear {
            quotesViewModel.fetchAllQuotes() // Load all quotes initially
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let container = NSPersistentContainer(name: "DataModel")
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    container.loadPersistentStores { _, error in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    let context = container.viewContext

    return QuotesView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = NSPersistentContainer(name: "DataModel")
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    container.loadPersistentStores { _, error in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    let context = container.viewContext

    return QuotesView(viewContext: context)
        .preferredColorScheme(.dark)
}
