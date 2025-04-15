//
//  NutritionSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 12/11/24.
//

import CoreData
import SwiftUI

struct NutritionSummaryView: View {
    @State private var nutritionViewModel: NutritionViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _nutritionViewModel = State(wrappedValue: NutritionViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: NutritionView(viewContext: viewContext)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("NUTRITION")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(AppGradients.summaryTitleTextGradient)
                    .padding(.leading, 5)
                    .padding(.bottom, -20)
                    .shadow(radius: 2, y: 1)

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "fork.knife")
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
    let context = NutritionSummaryView.createPreviewContext()
    NutritionSummaryView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = NutritionSummaryView.createPreviewContext()
    NutritionSummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension NutritionSummaryView {
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
