//
//  EditPinnedViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import Combine
import SwiftUI

@Observable final class EditPinnedViewModel {
    var searchText = ""
    var items = ["Art Therapy", "Journal", "Exercise",
                            "Sleep", "Mood", "Nutrition", "Books",
                            "Music", "Quotes", "Therapy", "Meditation", "Cycle"]
    var pinnedItems = [String]()
    var unpinnedItems = ["Art Therapy", "Journal", "Exercise",
                                    "Sleep", "Mood", "Nutrition", "Books",
                                    "Music", "Quotes", "Therapy", "Meditation", "Cycle"]
    var newItem = ""
    private var speechRecognizer: SpeechRecognizer?

    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var filteredPinnedItems: [String] {
        filteredItems.filter { pinnedItems.contains($0) }
    }

    var filteredUnpinnedItems: [String] {
        filteredItems.filter { unpinnedItems.contains($0) }
    }

    init(initialPinnedItems: [String]) {
        self.pinnedItems = initialPinnedItems
        // Initialize unpinnedItems with items that aren't pinned
        self.unpinnedItems = items.filter { !initialPinnedItems.contains($0) }
    }

    func dropList1(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
            _ = item.loadObject(ofClass: String.self) { droppedString, _ in
                if let theString = droppedString {
                    DispatchQueue.main.async {
                        self.pinnedItems.insert(theString, at: index)
                        self.unpinnedItems.removeAll { $0 == theString }
                    }
                }
            }
        }
    }

    func dropList2(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
            _ = item.loadObject(ofClass: String.self) { droppedString, _ in
                if let theString = droppedString {
                    DispatchQueue.main.async {
                        self.unpinnedItems.insert(theString, at: index)
                        self.pinnedItems.removeAll { $0 == theString }
                    }
                }
            }
        }
    }

    func movePinnedItems(from source: IndexSet, to destination: Int) {
        pinnedItems.move(fromOffsets: source, toOffset: destination)
    }

    func moveUnpinnedItems(from source: IndexSet, to destination: Int) {
        unpinnedItems.move(fromOffsets: source, toOffset: destination)
    }

    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func addItem() {
        guard !newItem.isEmpty else { return }
        withAnimation {
            items.append(newItem)
            newItem = ""
        }
    }

    func pinItem(_ item: String) {
        if let index = unpinnedItems.firstIndex(of: item) {
            unpinnedItems.remove(at: index)
            pinnedItems.append(item)
        }
    }

    func unpinItem(_ item: String) {
        if let index = pinnedItems.firstIndex(of: item) {
            pinnedItems.remove(at: index)
            unpinnedItems.append(item)
        }
    }

    func startSpeechRecognition(completion: @escaping (String) -> Void) throws {
        speechRecognizer = SpeechRecognizer()
        speechRecognizer?.transcribedTextHandler = completion
        try speechRecognizer?.startRecording()
    }

    func stopSpeechRecognition() {
        speechRecognizer?.stopRecording()
    }
}
