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

    init(viewContext: NSManagedObjectContext) {
        _quotesSummaryViewModel = StateObject(wrappedValue: QuotesSummaryViewModel(viewContext: viewContext))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("QUOTES")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "text.quote")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.gray, .yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .font(.largeTitle)

                VStack {
                    if let quote = quotesSummaryViewModel.quotes.first {
                        Text(quote.quoteContent ?? "No content")
                        Text("— \(quote.quoteAuthor ?? "Unknown")")
                    } else {
                        Text("No favorite quotes yet")
                    }
                }
            }
            .padding()
            .background(Color.almostBlack)
            .cornerRadius(10)
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let container = NSPersistentContainer(name: "QuotesDataModel") // Replace with your model name
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") // In-memory store
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
    let container = NSPersistentContainer(name: "QuotesDataModel") // Replace with your model name
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") // In-memory store
    container.loadPersistentStores { _, error in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    let context = container.viewContext

    return QuotesSummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}
