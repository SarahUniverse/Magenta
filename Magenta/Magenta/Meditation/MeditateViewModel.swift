//
//  MeditateViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/7/25.
//

import Combine
import CoreData

final class MeditateViewModel: ObservableObject {
    @Published var meditationSessions: [MeditationModel] = []
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        createInitialMeditationSessions()
        fetchMeditationSessions()
    }

    func fetchMeditationSessions() {
        let request: NSFetchRequest<MeditationEntity> = MeditationEntity.fetchRequest()

        do {
            let entities = try viewContext.fetch(request)
            meditationSessions = entities.map { MeditationModel(entity: $0)}
        } catch {
            print("Error fetching meditation sessions: \(error.localizedDescription)")
        }
    }

    func createInitialMeditationSessions() {
        // Check if sessions already exist
        let request: NSFetchRequest<MeditationEntity> = MeditationEntity.fetchRequest()
        let count = (try? viewContext.count(for: request)) ?? 0

        // Only create initial sessions if none exist
        guard count == 0 else { return }

        // Create initial meditation sessions
        let sessions: [(String, String, Int, String)] = [
            (
                "Affirmations",
                "Powerful Affirmations to Soothe Your Mind",
                15,
                "https://podcasts.apple.com/us/podcast/guided-meditation/id1555403722?i=1000689968511"
            ),
            (
                "Calm",
                "A Head-to-Toe Calm Meditation",
                11,
                "https://podcasts.apple.com/us/podcast/guided-meditation/id1555403722?i=1000690286790"
            ),
            (
                "Be Gentle",
                "A Meditation to Be Gentle with Yourself",
                20,
                "https://podcasts.apple.com/us/podcast/guided-meditation/id1555403722?i=1000692529865"
            ),
            (
                "Ocean Meditation",
                "Sleep: A Sleepy Ocean Meditation for Deep Rest",
                24,
                "https://podcasts.apple.com/us/podcast/guided-meditation/id1555403722?i=1000683704024"
            ),
            (
                "Sleep",
                "A Meditation Decompress Before Sleep",
                21,
                "https://podcasts.apple.com/us/podcast/guided-meditation/id1555403722?i=1000690690060"
            )
        ]

        // Create entities for each session
        sessions.forEach { session in
            let entity = MeditationEntity(context: viewContext)
            entity.id = UUID()
            entity.meditationTitle = session.0
            entity.meditationDescription = session.1
            entity.meditationDuration = Int64(session.2)

            // Create URL for meditation audio
            if let podcastURL = URL(string: session.3) {
                entity.meditationURL = podcastURL
            } else {
                // Fallback URL if audio file not found
                entity.meditationURL = URL(string: "https://example.com/meditations/\(session.3)")
            }
        }

        // Save the context
        do {
            try viewContext.save()
            print("Successfully created initial meditation sessions")
        } catch {
            print("Error saving meditation sessions: \(error.localizedDescription)")
        }
    }

}
