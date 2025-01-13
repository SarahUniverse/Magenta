//
//  ArtTherapyView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import SwiftUI

struct ArtTherapyView: View {
    @StateObject private var artTherapyViewModel: ArtTherapyViewModel

    init(viewContext: NSManagedObjectContext) {
        _artTherapyViewModel = StateObject(wrappedValue: ArtTherapyViewModel(viewContext: viewContext))
    }

    // MARK: - Private variables
    private var headerView: some View {
        HStack {
            Text("Art Therapy")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    private var ideaHeader: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lightbulb.max")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .foregroundStyle(.yellow)

            Text("Ideas for Activities:")
                .font(.title3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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

    private var addActivityButton: some View {
        Button(action: {
            artTherapyViewModel.showAddActivitySheet = true
        }) {
            Text("Add Activity")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }

    // MARK: - Main View Code
    var body: some View {
        VStack(spacing: 0) {
            headerView
            addActivityButton
            ideaHeader
            activityList
        }
        .navigationBarTitle("Art Therapy", displayMode: .inline)
        .sheet(isPresented: $artTherapyViewModel.showAddActivitySheet) {
            // Add activity sheet would go here
            Text("Add New Activity")
        }
    }
}

// MARK: Previews
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
