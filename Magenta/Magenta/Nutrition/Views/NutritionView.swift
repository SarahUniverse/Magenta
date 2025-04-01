//
//  NutritionView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

struct NutritionView: View {
    @State private var nutritionViewModel: NutritionViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _nutritionViewModel = State(wrappedValue: NutritionViewModel(viewContext: viewContext))
    }

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .green, location: 0),
            Gradient.Stop(color: .green.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .green.opacity(0.3), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: Body
    var body: some View {
        NavigationStack {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Nutrition Matters")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let context = NutritionView.createPreviewContext()
    NutritionView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let context = NutritionView.createPreviewContext()
    NutritionView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension NutritionView {
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
