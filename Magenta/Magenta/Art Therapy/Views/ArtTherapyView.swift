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

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .red, location: 0),
            Gradient.Stop(color: .orange, location: 0.057),
            Gradient.Stop(color: .yellow, location: 0.114),
            Gradient.Stop(color: .green, location: 0.171),
            Gradient.Stop(color: .blue, location: 0.228),
            Gradient.Stop(color: .indigo.opacity(0.6), location: 0.285),
            Gradient.Stop(color: .purple.opacity(0.3), location: 0.342),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

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

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ideaHeader
                    .padding(.top, 20)
                activityList
            }
            .navigationBarTitle("Art Therapy")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .sheet(isPresented: $artTherapyViewModel.showAddActivitySheet) {
                // Add activity sheet would go here
                Text("Add New Activity")
            }
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    return ArtTherapyView(viewContext: persistentContainer.viewContext)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    return ArtTherapyView(viewContext: persistentContainer.viewContext)
        .preferredColorScheme(.dark)
}
