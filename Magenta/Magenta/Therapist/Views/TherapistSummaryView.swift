//
//  TherapistSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData
import SwiftUI

struct TherapistSummaryView: View {
    @State private var therapistViewModel: TherapistViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _therapistViewModel = State(wrappedValue: TherapistViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: TherapistSearchView(viewContext: viewContext)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("THERAPY")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(AppGradients.summaryTitleTextGradient)
                    .padding(.leading, 5)
                    .padding(.bottom, -20)
                    .shadow(radius: 5, y: 3)

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "brain.head.profile")
                        .foregroundStyle(AppGradients.summaryIconGradient)
                        .font(.largeTitle)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    NavigationChevron()
                }
                .padding(25)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(GlassBackground())
            }
        }
    }

}

// MARK: - Previews
#Preview ("Light Mode") {
    let context = TherapistSummaryView.createPreviewContext()
    TherapistSummaryView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = TherapistSummaryView.createPreviewContext()
    TherapistSummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension TherapistSummaryView {
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
