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
    @Published private(set) var colors: Colors
    @Environment(\.colorScheme) var colorScheme

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
        items = [
            DiscoverItemModel(icon: Image(systemName: "paintpalette"), title: "Art Therapy"),
            DiscoverItemModel(icon: Image(systemName: "book"), title: "Books that Help Me"),
            DiscoverItemModel(icon: Image(systemName: "figure.run"), title: "Get Up and Move"),
            DiscoverItemModel(icon: Image(systemName: "pencil.and.scribble"), title: "My Thoughts"),
            DiscoverItemModel(icon: Image(systemName: "moon.zzz"), title: "Sleep or Nightmare Time?"),
            DiscoverItemModel(icon: Image(systemName: "face.smiling"), title: "What's My Mood?"),
            DiscoverItemModel(icon: Image(systemName: "fork.knife"), title: "Nutrition Matters"),
            DiscoverItemModel(icon: Image(systemName: "music.note.list"), title: "Mental Health Playlist"),
            DiscoverItemModel(icon: Image(systemName: "text.quote"), title: "Quotes that Move Me"),
            DiscoverItemModel(icon: Image(systemName: "brain.head.profile"), title: "Professional Help Search"),
            DiscoverItemModel(icon: Image(systemName: "apple.meditate"), title: "Time to Chill and Meditate"),
            DiscoverItemModel(icon: Image(systemName: "calendar.badge.clock"), title: "Track My Cycle")
        ]
    }

}
