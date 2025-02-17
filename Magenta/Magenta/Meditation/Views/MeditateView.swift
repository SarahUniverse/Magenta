//
//  MeditateView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

struct MeditateView: View {
    @StateObject private var meditateViewModel: MeditateViewModel

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .cyan, location: 0),
            Gradient.Stop(color: .darkBlue.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .darkBlue.opacity(0.7), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    init(viewContext: NSManagedObjectContext) {
        _meditateViewModel = StateObject(wrappedValue: MeditateViewModel(viewContext: viewContext))
    }

    // MARK: Main View
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                meditationSessionsList
            }
            .navigationTitle("Meditate")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                toolbarContent
            }
        }
    }

    // MARK: - Private Variables
    private var meditationSessionsList: some View {
        VStack {
            ForEach(meditateViewModel.meditationSessions) { session in
                meditationCard(for: session)
            }
        }
        .padding()
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(.darkBlue)
            .frame(height: 100)
            .shadow(radius: 3)
            .visualEffect { content, proxy in
                let frame = proxy.frame(in: .scrollView(axis: .vertical))
                let distance = min(0, frame.minY)

                return content
                    .hueRotation(.degrees(frame.origin.y / 10))
                    .scaleEffect(1 + distance / 700)
                    .offset(y: -distance / 1.25)
                    .brightness(-distance / 400)
                    .blur(radius: -distance / 50)
            }
    }

    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Image(systemName: "person.circle")
        }
    }

    // MARK: - Private Functions
    private func cardContent(for session: MeditationModel) -> some View {
        VStack {
            HStack {
                Text(session.meditationTitle)
                    .foregroundStyle(.white)
                    .bold()
                Text("\(session.meditationDuration) min")
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()

            HStack {
                Text(session.meditationDescription)
                    .foregroundStyle(.white)
                    .font(.caption)
                    .lineLimit(2)
                Spacer()
            }
            .padding(.horizontal)
        }
    }

    private func meditationCard(for session: MeditationModel) -> some View {
        ZStack {
            cardBackground
            cardContent(for: session)
        }
    }

}

// MARK: - Preview
#Preview ("Light Mode") {
    let context = PersistenceController.preview.container.viewContext
    return MeditateView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = PersistenceController.preview.container.viewContext
    return MeditateView(viewContext: context)
        .preferredColorScheme(.dark)
}

// For preview content
struct PersistenceController {
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        // Add any preview data setup here
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
