//
//  TherapistSearchView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import SwiftUI

struct TherapistSearchView: View {
    @State private var therapistViewModel: TherapistViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _therapistViewModel = State(wrappedValue: TherapistViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationStack {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Find a Therapist")
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
    let context = TherapistSearchView.createPreviewContext()
    TherapistSearchView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let context = TherapistSearchView.createPreviewContext()
    TherapistSearchView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension TherapistSearchView {
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
