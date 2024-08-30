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

                    Button(action: {
                        if speechRecognizer.audioEngine.isRunning {
                            speechRecognizer.stopRecording()
                        } else {
                            do {
                                try speechRecognizer.startRecording()
                            } catch {
                                print("Failed to start recording: \(error.localizedDescription)")
                            }
                        }
                    }) {
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
                            }
                        }
                        .onDelete(perform: deleteItem)
                        .onMove(perform: moveItem)
                }

                Section(header: Text("Mood")) {
                    ForEach(moodItems, id: \.self) { item in
                        HStack {
                            Image(systemName: "pin.fill")
                                .foregroundStyle(.yellow)
                            Text(item)
                        }
                    }
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

    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func moveItem(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
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
