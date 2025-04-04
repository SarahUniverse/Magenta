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
                CycleView()
            default:
                Text("View Not Found")
            }
    }

    // MARK: - Private Functions
    private func loadDiscoverItemData() {
        items = [
            DiscoverItemModel(
                icon: Image(systemName: "paintpalette").symbolRenderingMode(.multicolor),
                title: "Art Therapy",
                iconColor: .purple
            ),
            DiscoverItemModel(
                icon: Image(systemName: "pencil.and.scribble"),
                title: "Journal",
                iconColor: .blue
            ),
            DiscoverItemModel(
                icon: Image(systemName: "figure.run"),
                title: "Exercise",
                iconColors: [.yellow, .orange, .red]
            ),
            DiscoverItemModel(
                icon: Image(systemName: "moon.zzz.fill").symbolRenderingMode(.palette),
                title: "Sleep",
                iconColors: [.mediumBlue, .indigo]
            ),
            DiscoverItemModel(
                icon: Image(systemName: "theatermasks.fill").symbolRenderingMode(.palette),
                title: "Mood Tracker",
                iconColors: [.yellow, .blue]
            ),
            DiscoverItemModel(
                icon: Image(systemName: "fork.knife"),
                title: "Nutrition",
                iconColor: .green
            ),
            DiscoverItemModel(
                icon: Image(systemName: "books.vertical"),
                title: "Books",
                iconColor: .brown
            ),
            DiscoverItemModel(
                icon: Image(systemName: "music.note.list"),
                title: "Playlists",
                iconColor: .hotPink
            ),
            DiscoverItemModel(
                icon: Image(systemName: "text.quote"),
                title: "Quotes",
                iconColors: [.gray, .yellow]
            ),
            DiscoverItemModel(
                icon: Image(systemName: "brain.head.profile"),
                title: "Professional Help",
                iconColor: .teal
            ),
            DiscoverItemModel(
                icon: Image(systemName: "figure.mind.and.body"),
                title: "Meditate",
                iconColors: [.cyan, .darkBlue]
            ),
            DiscoverItemModel(
                icon: Image(systemName: "calendar.badge.clock"),
                title: "Cycle",
                iconColor: .pink
            )
        ]
    }

}
