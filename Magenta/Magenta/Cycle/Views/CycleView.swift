//
//  CycleView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

struct CycleView: View {
    @State private var cycleViewModel: CycleViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _cycleViewModel = State(wrappedValue: CycleViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationStack {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Track My Cycle")
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
    let viewContext = CycleView.createPreviewContext()
    CycleView(viewContext: viewContext)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let viewContext = CycleView.createPreviewContext()
    CycleView(viewContext: viewContext)
        .preferredColorScheme(.dark)
}

extension CycleView {
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
