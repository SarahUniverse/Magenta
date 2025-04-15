//
//  ExerciseSummary.swift
//  Magenta
//
//  Created by Sarah Clark on 12/11/24.
//

import CoreData
import SwiftUI

struct ExerciseSummaryView: View {
    @State private var exerciseViewModel: ExerciseViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _exerciseViewModel = State(wrappedValue: ExerciseViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: ExerciseView(viewContext: viewContext)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("EXERCISE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(UIColor.secondaryLabel))
                    .padding(.leading, 5)
                    .padding(.bottom, -20)

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "figure.run")
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
    let context = ExerciseSummaryView.createPreviewContext()
    ExerciseSummaryView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = ExerciseSummaryView.createPreviewContext()
    ExerciseSummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension ExerciseSummaryView {
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
