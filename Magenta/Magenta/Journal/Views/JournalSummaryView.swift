//
//  JournalSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData
import SwiftUI

struct JournalSummaryView: View {
    @State private var journalViewModel: JournalViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _journalViewModel = State(wrappedValue: JournalViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
#if canImport(JournalingSuggestions)
        NavigationLink(destination: JournalView(viewContext: viewContext)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("JOURNAL")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "pencil.and.scribble")
                        .foregroundStyle(.blue)
                        .font(.largeTitle)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                            .font(.subheadline)
                            .foregroundStyle(.gray)

                        Button("Review") { }
                            .foregroundStyle(.blue)
                    }
                    Spacer()
                    NavigationChevron()
                }
                .padding(25)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(GlassBackground())
            }
        }
#endif
    }

}

// MARK: - Previews
#Preview ("Light Mode") {
    let context = JournalSummaryView.createPreviewContext()
    JournalSummaryView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = JournalSummaryView.createPreviewContext()
    JournalSummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension JournalSummaryView {
    static func createPreviewContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack for preview: \(error)")
            }
        }
        return container.viewContext
    }

}
