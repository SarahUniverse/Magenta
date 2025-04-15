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

    // MARK: Body
    var body: some View {
        NavigationStack {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Nutrition Matters")
            .background(AppGradients.backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.white, .indigo)
                        .shadow(radius: 5, y: 3)
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
