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
        VStack(alignment: .leading) {
            headerText
            NavigationLink(destination: QuotesView(viewContext: viewContext)) {
                mainContent
                    .padding(20)
                    .background(glassBackground)
                    .cornerRadius(15)
            }
        }
        .onAppear {
            quotesSummaryViewModel.fetchMostRecentFavoriteQuote()
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
            navigationChevron
        }
    }

    private var quoteContent: some View {
        VStack {
            if let quote = quotesSummaryViewModel.quotes.first {
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
                            .foregroundStyle(.yellow)
                    )
            }
        }
        .padding(.vertical, 5)
    }

    private var navigationChevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.gray)
            .padding(.bottom, 70)
    }

    private var heartIcon: some View {
        ZStack {
            grayGradientRectangle
            Image(systemName: "heart.fill")
                .foregroundStyle(.yellow)
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
            .foregroundStyle(.gray)
            .padding(.leading, 5)
            .padding(.bottom, -5)
    }

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
