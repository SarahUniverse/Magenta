//
//  ExerciseView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

struct ExerciseView: View {
    @State private var exerciseViewModel: ExerciseViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _exerciseViewModel = State(wrappedValue: ExerciseViewModel(viewContext: viewContext))
    }

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .yellow.opacity(0.8), location: 0),
            Gradient.Stop(color: .orange.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .red.opacity(0.6), location: 0.2),
            Gradient.Stop(color: .red.opacity(0.4), location: 0.3),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                Text("Step Count: \(exerciseViewModel.stepCount)")
            }
            .navigationTitle("Get Up and Move")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
            .onAppear {
                // exerciseViewModel.fetchSteps()
            }
        }
    }

}

// MARK: - Previews
#Preview ("Light Mode") {
    let context = ExerciseView.createPreviewContext()
    ExerciseView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = ExerciseView.createPreviewContext()
    ExerciseView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension ExerciseView {
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
