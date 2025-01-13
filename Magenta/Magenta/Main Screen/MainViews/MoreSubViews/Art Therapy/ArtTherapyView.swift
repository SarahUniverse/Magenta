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

    // MARK: - Main View Code
    var body: some View {
        VStack(spacing: 0) {
            animationHeader
            ideaHeader
            activityList
        }
    }

    // MARK: - Private variables
    private var animationHeader: some View {
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
                paintbrushAnimation
            }
        }
        .onAppear {
            artTherapyViewModel.startPaintingAnimation()
        }
        .frame(height: 100)
    }

    private var paintbrushAnimation: some View {
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

    private var ideaHeader: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lightbulb.max")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .padding(.top, 20)
                .foregroundStyle(.yellow)

            Text("Ideas for Activities:")
                .font(.title3)
                .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
