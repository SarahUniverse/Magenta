//
//  ArtTherapyViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/11/25.
//

import CoreData
import SwiftUI

final class ArtTherapyViewModel: ObservableObject {
    @Published var revealProgress: CGFloat = 0.0
    @Published var artTherapyActivities: [ArtTherapyModel] = []

    private var animationTimer: Timer?
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext

        // Check if activities exist, if not, create them
        let request: NSFetchRequest<ArtTherapyEntity> = ArtTherapyEntity.fetchRequest()

        do {
            let entities = try viewContext.fetch(request)

            createInitialArtTherapyActivities()

            fetchArtTherapyActivities()
        } catch {
            print("Error checking Art Therapy Activities: \(error.localizedDescription)")
        }
    }

    // swiftlint:disable line_length
    private func createInitialArtTherapyActivities() {
        let activities = [
            (
                name: "Emotion Painting",
                description: "Choose colors that represent different emotions you're feeling or have felt recently. Use these colors to create a painting or abstract art piece where each color represents a specific emotion. You could layer colors, mix them, or keep them separate to symbolize how these emotions interact or coexist within you.",
                therapeuticValue: "Helps in identifying, expressing, and processing emotions through visual representation."
            ),
            (
                name: "Memory Collage",
                description: "Gather old magazines, photographs, or print images from online sources. Create a collage that represents memories, either positive or negative, from your life. You can also include words or phrases that resonate with these memories.",
                therapeuticValue: "Assists in storytelling, processing past events, and can be a way to honor or release memories."
            ),
            (
                name: "Sculpting with Clay",
                description: "Use clay to sculpt something that represents an obstacle or challenge in your life. Alternatively, sculpt something that symbolizes freedom, peace, or a goal you're working towards.",
                therapeuticValue: "The tactile nature of clay can be soothing, and the act of shaping can symbolize taking control over one's life circumstances or exploring new forms of expression."
            ),
            (
                name: "Mandala Drawing",
                description: "Draw or color in a mandala, which is a circular design that represents the universe in Hindu and Buddhist symbolism. You can start with a pre-printed mandala or create your own. Choose your patterns and colors intuitively as you work.",
                therapeuticValue: "Promotes relaxation, focus, and can symbolize the journey towards balance and wholeness."
            ),
            (
                name: "Self-Portrait Exploration",
                description: "Create a self-portrait, but with a twist—depict how you feel inside rather than how you look outside. You could use abstract forms, symbols, or even collage elements to represent different aspects of your personality, emotions, or life stages.",
                therapeuticValue: "Encourages self-reflection, self-acceptance, and can be a profound way to explore identity and self-perception."
            )
        ]

        activities.forEach { activity in
            let newActivity = ArtTherapyEntity(context: viewContext)
            newActivity.id = UUID()
            newActivity.activityName = activity.name
            newActivity.activityDescription = activity.description
            newActivity.therapeuticValue = activity.therapeuticValue
        }

        do {
            try viewContext.save()
        } catch {
            print("Error saving initial Art Therapy Activities: \(error.localizedDescription)")
        }
    }
    // swiftlint:enable line_length

    func startPaintingAnimation() {
        revealProgress = 0.0

        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            self.revealProgress += 0.01

            if self.revealProgress >= 1.0 {
                timer.invalidate()
               self.revealProgress = 1.0
            }
        }
    }

    func createArtTherapyActivity(
        activityDescription: String,
        activityName: String,
        therapeuticValue: String
    ) {
        let newActivity = ArtTherapyEntity(context: viewContext)
        newActivity.id = UUID()
        newActivity.activityDescription = activityDescription
        newActivity.activityName = activityName
        newActivity.therapeuticValue = therapeuticValue

        do {
            try viewContext.save()
            fetchArtTherapyActivities()
        } catch {
            print("Error saving Art Therapy Activity: \(error.localizedDescription)")
        }
    }

    func deleteArtTherapyActivity(_ activity: ArtTherapyModel) {
        guard let entity = fetchEntity(for: activity) else { return }

        viewContext.delete(entity)

        do {
            try viewContext.save()
            fetchArtTherapyActivities()
        } catch {
            print("Error deleting Art Therapy Activity: \(error.localizedDescription)")
        }
    }

    // MARK: - Private functions
    private func fetchArtTherapyActivities() {
        let request: NSFetchRequest<ArtTherapyEntity> = ArtTherapyEntity.fetchRequest()

        do {
            let entities = try viewContext.fetch(request)
            artTherapyActivities = entities.map { ArtTherapyModel(entity: $0) }
        } catch {
            print("Error fetching Art Therapy Activities: \(error.localizedDescription)")
        }
    }

    private func fetchEntity(for model: ArtTherapyModel) -> ArtTherapyEntity? {
        let request: NSFetchRequest<ArtTherapyEntity> = ArtTherapyEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)

        do {
            return try viewContext.fetch(request).first
        } catch {
            print("Error fetching entity: \(error.localizedDescription)")
            return nil
        }
    }

}
