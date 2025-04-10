//
//  DiscoverViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/13/25.
//

import CoreData
import SwiftUI

@Observable final class DiscoverViewModel {
    let viewContext: NSManagedObjectContext
    private var speechRecognizer: SpeechRecognizer?
    var items: [DiscoverItemModel] = []
    var colors: Colors
    var shouldShowLoginView = false
    private let sleepViewModel: SleepViewModel
    private let healthKitManager: HealthKitManager

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        self.viewContext = viewContext
        self.colors = Colors(colorScheme: colorScheme)
        self.healthKitManager = HealthKitManager.shared
        self.sleepViewModel = SleepViewModel(viewContext: viewContext, healthKitManager: healthKitManager)
        loadDiscoverItemData()
    }

    func signOut() {
        self.shouldShowLoginView = true
    }

    func updateColorScheme(_ colorScheme: ColorScheme) {
        colors = Colors(colorScheme: colorScheme)
    }

    func filteredItems(searchText: String) -> [DiscoverItemModel] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    func startSpeechRecognition(completion: @escaping (String) -> Void) throws {
        speechRecognizer = SpeechRecognizer()
        speechRecognizer?.transcribedTextHandler = completion
        try speechRecognizer?.startRecording()
    }

    func stopSpeechRecognition() {
        speechRecognizer?.stopRecording()
    }

    @ViewBuilder
    func destinationView(for item: DiscoverItemModel) -> some View {
        switch item.title {
            case "Art Therapy":
                ArtTherapyView(viewContext: viewContext)
            case "Books":
                BooksView(viewContext: viewContext)
            case "Exercise":
                ExerciseView(viewContext: viewContext)
             // TODO: Add back
            // case "Journal":
                // JournalView(viewContext: viewContext)
            case "Sleep":
                SleepView(viewContext: viewContext)
            case "Mood Tracker":
                MoodView(viewContext: viewContext)
            case "Nutrition":
                NutritionView(viewContext: viewContext)
            case "Playlists":
                PlaylistsView(viewContext: viewContext)
            case "Quotes":
                QuotesView(viewContext: viewContext)
            case "Professional Help":
                TherapistSearchView(viewContext: viewContext)
            case "Meditate":
                MeditationView(viewContext: viewContext)
            case "Cycle":
                CycleView(viewContext: viewContext)
            default:
                Text("View Not Found")
            }
    }

    // MARK: - Private Functions
    private func loadDiscoverItemData() {
        items = [
            DiscoverItemModel(
                icon: Image(systemName: "paintpalette"),
                title: "Art Therapy",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "pencil.and.scribble"),
                title: "Journal",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "figure.run"),
                title: "Exercise",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "moon.zzz.fill").symbolRenderingMode(.palette),
                title: "Sleep",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "theatermasks.fill").symbolRenderingMode(.palette),
                title: "Mood Tracker",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "fork.knife"),
                title: "Nutrition",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "books.vertical"),
                title: "Books",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "music.note.list"),
                title: "Playlists",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "text.quote"),
                title: "Quotes",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "brain.head.profile"),
                title: "Professional Help",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "figure.mind.and.body"),
                title: "Meditate",
                iconColor: AppGradients.iconGradient
            ),
            DiscoverItemModel(
                icon: Image(systemName: "calendar.badge.clock"),
                title: "Cycle",
                iconColor: AppGradients.iconGradient
            )
        ]
    }

}
