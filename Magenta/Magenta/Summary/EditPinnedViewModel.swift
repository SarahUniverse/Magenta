//
//  EditPinnedViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//


import Combine
import SwiftUI

final class EditPinnedViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var items = ["Mood", "Meditate", "Exercise", "Nutrition", "Sleep"]
    @Published var pinnedItems = ["Mood", "Meditate", "Exercise", "Nutrition", "Sleep"]
    @Published var moodItems = ["Happy", "Sad", "Angry", "Tired", "Excited"]
    @Published var newItem = ""

    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func dropList1(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
            _ = item.loadObject(ofClass: String.self) { droppedString, _ in
                if let theString = droppedString {
                    DispatchQueue.main.async {
                        self.pinnedItems.insert(theString, at: index)
                        self.moodItems.removeAll { $0 == theString }
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
                        self.moodItems.insert(theString, at: index)
                        self.pinnedItems.removeAll { $0 == theString }
                    }
                }
            }
        }
    }

    func movePinnedItems(from source: IndexSet, to destination: Int) {
        pinnedItems.move(fromOffsets: source, toOffset: destination)
    }

    func moveMoodItems(from source: IndexSet, to destination: Int) {
        moodItems.move(fromOffsets: source, toOffset: destination)
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
}
