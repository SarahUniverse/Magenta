//
//  DiscoverViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/13/25.
//

import CoreData
import SwiftUI

final class DiscoverViewModel: ObservableObject {
    let viewContext: NSManagedObjectContext
    private var speechRecognizer: SpeechRecognizer?
    @Published var items: [DiscoverItemModel] = []
    @Published var colors: Colors
    @Published var shouldShowLoginView = false

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        self.viewContext = viewContext
        self.colors = Colors(colorScheme: colorScheme)
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
        case "Books that Help Me":
            SelfHelpBooksView()
        case "Get Up and Move":
            ExerciseView()
         // TODO: Add back
        // case "My Thoughts":
            // JournalView(viewContext: viewContext)
        case "Sleep or Nightmare Time":
            SleepView()
        case "What's My Mood?":
            MoodView()
        case "Nutrition Matters":
            NutritionView()
        case "Mental Health Playlists":
            MentalHealthPlaylistsView()
        case "Quotes that Move Me":
            HelpfulQuotesView()
        case "Professional Help Search":
            TherapistSearchView()
        case "Time to Chill and Meditate":
            MeditateView()
        case "Track My Cycle":
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
                title: "My Thoughts",
                iconColor: .blue
            ),
            DiscoverItemModel(
                icon: Image(systemName: "figure.run"),
                title: "Get Up and Move",
                iconColors: [.yellow, .orange, .red]
            ),
            DiscoverItemModel(
                icon: Image(systemName: "moon.zzz.fill").symbolRenderingMode(.palette),
                title: "Sleep or Nightmare Time?",
                iconColors: [.mediumBlue, .indigo]
            ),
            DiscoverItemModel(
                icon: Image(systemName: "theatermasks.fill").symbolRenderingMode(.palette),
                title: "What's My Mood?",
                iconColors: [.yellow, .blue]
            ),
            DiscoverItemModel(
                icon: Image(systemName: "fork.knife"),
                title: "Nutrition Matters",
                iconColor: .green
            ),
            DiscoverItemModel(
                icon: Image(systemName: "books.vertical"),
                title: "Books that Help Me",
                iconColor: .brown
            ),
            DiscoverItemModel(
                icon: Image(systemName: "music.note.list"),
                title: "Mental Health Playlists",
                iconColor: .hotPink
            ),
            DiscoverItemModel(
                icon: Image(systemName: "text.quote").symbolRenderingMode(.palette),
                title: "Quotes that Move Me",
                iconColors: [.gray, .yellow]
            ),
            DiscoverItemModel(
                icon: Image(systemName: "brain.head.profile"),
                title: "Professional Help Search",
                iconColor: .teal
            ),
            DiscoverItemModel(
                icon: Image(systemName: "figure.mind.and.body"),
                title: "Time to Chill and Meditate",
                iconColors: [.cyan, .darkBlue]
            ),
            DiscoverItemModel(
                icon: Image(systemName: "calendar.badge.clock"),
                title: "Track My Cycle",
                iconColor: .pink
            )
        ]
    }

}
