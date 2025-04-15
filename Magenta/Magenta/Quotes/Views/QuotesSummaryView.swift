//
//  QuotesSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData
import SwiftUI

struct QuotesSummaryView: View {
    @State private var quotesViewModel: QuotesViewModel
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _quotesViewModel = State(wrappedValue: QuotesViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            headerText
            NavigationLink(destination: QuotesView(viewContext: viewContext)) {
                mainContent
                    .padding(25)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(GlassBackground())
            }
        }
        .onAppear {
            quotesViewModel.fetchMostRecentFavoriteQuote()
        }
    }

    // MARK: Private Variables
    private var mainContent: some View {
        HStack(alignment: .center, spacing: 10) {
            quoteContent
                .padding(.top, -10)
            Spacer()
            heartIcon
                .padding(.top, -10)
            Spacer()
            NavigationChevron()
                .padding(.bottom, 70)
        }
    }

    private var quoteContent: some View {
        VStack {
            if let quote = quotesViewModel.quotesEntity.first {
                Text(quote.quoteContent ?? "No content")
                    .font(.system(.body, design: .serif))
                    .foregroundStyle(.gray)

                Text("— \(quote.quoteAuthor ?? "Unknown")")
                    .font(.system(.caption, design: .serif))
                    .foregroundStyle(.gray)
            } else {
                Text("No favorite quotes yet")
                    .font(.system(.title3, design: .serif))
                    .foregroundStyle(.gray)
                    .overlay(
                        Image(systemName: "sparkles")
                            .font(.caption2)
                            .foregroundStyle(AppGradients.summaryIconGradient)
                    )
            }
        }
        .padding(.vertical, 5)
    }

    private var heartIcon: some View {
        ZStack {
            grayGradientRectangle
            Image(systemName: "heart.fill")
                .foregroundStyle(AppGradients.summaryIconGradient)
                .font(.system(size: 60))
                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
        }
        .padding(.top, 10)
    }

    private var grayGradientRectangle: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(
                LinearGradient(
                    colors: [.gray.opacity(0.5),
                             .gray.opacity(0.5),
                             .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 80, height: 80)
            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
    }

    private var headerText: some View {
        Text("QUOTES")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(Color(UIColor.secondaryLabel))
            .padding(.leading, 5)
            .padding(.bottom, -20)
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
