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
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        _artTherapyViewModel = StateObject(wrappedValue: ArtTherapyViewModel(viewContext: viewContext))
        self.viewContext = viewContext
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                AnimatedGradientBackgroundView(revealProgress: $artTherapyViewModel.revealProgress)
                    .frame(height: 100)

                HStack {
                    Text("Art Therapy")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                }
                .padding(.top, 20)

                if artTherapyViewModel.revealProgress < 1.0 {
                    Image(systemName: "paintbrush.pointed.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: CGFloat(artTherapyViewModel.revealProgress * UIScreen.main.bounds.width), y: -15)
                }
            }
            .onAppear {
                artTherapyViewModel.startPaintingAnimation()
            }
            .frame(height: 100)

            List {
                ForEach(artTherapyViewModel.artTherapyActivities) { activity in
                    VStack(alignment: .leading) {
                        Text(activity.activityName)
                            .font(.headline)
                        Text(activity.activityDescription)
                            .font(.subheadline)
                    }
                }
            }
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
