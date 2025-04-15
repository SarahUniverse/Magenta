//
//  ArtTherapyView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import SwiftUI

struct ArtTherapyView: View {
    @State private var artTherapyViewModel: ArtTherapyViewModel

    init(viewContext: NSManagedObjectContext) {
        _artTherapyViewModel = State(wrappedValue: ArtTherapyViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ideaHeader
                    .padding(.top, 20)
                activityList
            }
            .navigationBarTitle("Art Therapy")
            .background(AppGradients.backgroundGradient)
            .scrollContentBackground(.hidden)
            .sheet(isPresented: $artTherapyViewModel.showAddActivitySheet) {
                // Add activity sheet would go here
                Text("Add New Activity")
            }
        }
    }

    // MARK: - Private variables
    private var ideaHeader: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lightbulb.max.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .foregroundStyle(.yellow)
                .shadow(radius: 2)

            Text("Ideas for Activities:")
                .font(.title3)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }

    private var activityList: some View {
        List {
            ForEach(artTherapyViewModel.artTherapyActivities, id: \.id) { activity in
                Section(header: Text(activity.activityName)) {
                    VStack(alignment: .leading) {
                        Text(activity.activityDescription)
                            .font(.subheadline)
                            .padding(.bottom, 5)

                        Text(activity.therapeuticValue)
                            .font(.caption)
                            .italic()
                    }
                }
            }
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let context = ArtTherapyView.createPreviewContext()
    ArtTherapyView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let context = ArtTherapyView.createPreviewContext()
    ArtTherapyView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension ArtTherapyView {
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
