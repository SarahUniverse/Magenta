//
//  DiscoverViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/13/25.
//

import CoreData
import SwiftUI

final class DiscoverViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext
    private var speechRecognizer: SpeechRecognizer?
    @Published var items: [DiscoverItemModel] = []
    @Published private(set) var colors: Colors

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        self.viewContext = viewContext
        self.colors = Colors(colorScheme: colorScheme)
        loadInitialData()
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

    // MARK: - Private Functions
    private func loadInitialData() {
        // Load your initial data here
        items = [
            DiscoverItemModel(title: "Art Therapy"),
            DiscoverItemModel(title: "Self Help Books"),
            DiscoverItemModel(title: "Exercise"),
            DiscoverItemModel(title: "Journal")
            // Add more items as needed
        ]
    }

}

/*ArtTherapyView
SelfHelpBooksView
CycleView - shown only for females
ExerciseView
JournalView
MeditationView
MoodView
NutritionView
MentalHealthPlaylistView
HelpfulQuotesView
SleepView
TherapistSearchView*/
