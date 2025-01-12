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
        fetchArtTherapyActivities()
    }

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
