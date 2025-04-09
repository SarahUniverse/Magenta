//
//  CycleSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData
import SwiftUI

struct CycleSummaryView: View {
    @State private var cycleViewModel: CycleViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _cycleViewModel = State(wrappedValue: CycleViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationLink(destination: CycleView(viewContext: viewContext)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("CYCLE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                    .padding(.leading, 5)
                    .padding(.bottom, -20)

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "calendar.badge.clock")
                        .foregroundStyle(.pink)
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
    }

}

// MARK: - Previews
#Preview ("Light Mode") {
    let context = CycleSummaryView.createPreviewContext()
    CycleSummaryView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = CycleSummaryView.createPreviewContext()
   CycleSummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension CycleSummaryView {
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
