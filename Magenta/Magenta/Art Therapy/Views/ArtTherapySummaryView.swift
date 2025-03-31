//
//  ArtTherapySummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData
import SwiftUI

struct ArtTherapySummaryView: View {
    @State private var artTherapyViewModel: ArtTherapyViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _artTherapyViewModel = State(wrappedValue: ArtTherapyViewModel(viewContext: viewContext))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ART THERAPY")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "paintpalette")
                    .symbolRenderingMode(.multicolor)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)

                    Button("Review") { }
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            .background(GlassBackground())
            .cornerRadius(10)
        }
    }
}

// MARK: - Previews
#Preview ("Light Mode") {
    let context = ArtTherapySummaryView.createPreviewContext()
    ArtTherapySummaryView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = ArtTherapySummaryView.createPreviewContext()
    ArtTherapySummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension ArtTherapySummaryView {
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
