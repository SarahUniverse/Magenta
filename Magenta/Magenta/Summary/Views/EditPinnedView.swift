//
//  EditPinnedView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/23/24.
//

import SwiftUI

struct EditPinnedView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var items = ["Mood", "Meditate", "Exercise", "Nutrition", "Sleep"]
    @State private var newItem = ""
    @State private var pinnedItems = ["Mood", "Meditate", "Exercise", "Nutrition", "Sleep"]
    @State private var moodItems = ["Happy", "Sad", "Angry", "Tired", "Excited"]
    @StateObject private var speechRecognizer = SpeechRecognizer()

    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)

                    Button {
                        if speechRecognizer.audioEngine.isRunning {
                            speechRecognizer.stopRecording()
                        } else {
                            do {
                                try speechRecognizer.startRecording()
                            } catch {
                                print("Failed to start recording: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Image(systemName: speechRecognizer.audioEngine.isRunning ? "mic.fill" : "mic")
                            .foregroundColor(.blue)
                    }
                }
                .onReceive(speechRecognizer.$transcribedText) { transcribedText in
                    self.searchText = transcribedText
                }

               Section(header: Text("Pinned")) {
                    ForEach(pinnedItems, id: \.self) { item in
                        HStack {
                            Image(systemName: "pin.slash.fill")
                                .foregroundStyle(.red)
                            Text(item)
                                .onDrag { NSItemProvider(object: item as NSString) }
                            Spacer()
                            Image(systemName: "line.3.horizontal")
                                .foregroundStyle(.gray)
                        }
                    }
                    .onDelete(perform: deleteItem)
                    .onMove(perform: movePinnedItems)
                    .onInsert(of: ["public.txt"], perform: dropList1)
               }

                Section(header: Text("Mood")) {
                    ForEach(moodItems, id: \.self) { item in
                        HStack {
                            Image(systemName: "pin.fill")
                                .foregroundStyle(.yellow)
                            Text(item)
                                .onDrag { NSItemProvider(object: item as NSString) }
                        }
                    }
                    .onMove(perform: moveMoodItems)
                    .onInsert(of: ["public.txt"], perform: dropList2)
                }

            }
            .navigationTitle("Edit Pinned")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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

#Preview {
    EditPinnedView()
}
