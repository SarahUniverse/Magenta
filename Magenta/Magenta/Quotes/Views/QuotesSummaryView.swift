//
//  QuotesSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData
import SwiftUI

struct QuotesSummaryView: View {
    @StateObject private var quotesSummaryViewModel: QuotesSummaryViewModel
    @Environment(\.colorScheme) var colorScheme
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _quotesSummaryViewModel = StateObject(wrappedValue: QuotesSummaryViewModel(viewContext: viewContext))
    }

    // MARK: Body
    var body: some View {
        NavigationLink(destination: QuotesView(viewContext: viewContext)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("QUOTES")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                    .padding(.leading, 5)
                    .padding(.bottom, -20)

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.yellow)
                        /*.foregroundStyle(
                            LinearGradient(
                                colors: [.gray, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )*/
                        .font(.largeTitle)
                        .padding(.top, 10)
                    Spacer()
                    VStack {
                        if let quote = quotesSummaryViewModel.quotes.first {
                            Text(quote.quoteContent ?? "No content")
                            Text("— \(quote.quoteAuthor ?? "Unknown")")
                        } else {
                            Text("No favorite quotes yet")
                        }
                    }
                    .font(.system(.body, design: .serif))
                    .foregroundStyle(.gray)
                    .padding(.top, 10)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 10)
                        .padding(.top, 10)

                }
                .padding(20)
                .background(glassBackground)
            }
            .onAppear {
                quotesSummaryViewModel.fetchMostRecentFavoriteQuote()
            }
        }
    }

    // MARK: Private Variables
    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(colorScheme == .dark ? 0.3 : 0.5),
                                .white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        .black.opacity(0.1),
                        lineWidth: 1
                    )
                    .blur(radius: 1)
                    .mask(RoundedRectangle(cornerRadius: 15).fill(.black))
            }
            .padding(.top, 10)
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

    return QuotesSummaryView(viewContext: context)
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

    return QuotesSummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}
