//
//  EditPinnedView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/23/24.
//

import SwiftUI

struct EditPinnedView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var pinnedItems: [String]
    @StateObject private var editPinnedViewModel: EditPinnedViewModel
    @State private var searchText = ""
    @State private var isListening = false
    @State private var showError = false
    @State private var errorMessage = ""

    private var searchSection: some View {
        SearchView(
            text: $searchText,
            isListening: $isListening,
            startListening: {
                startSpeechRecognition()
            },
            stopListening: {
                editPinnedViewModel.stopSpeechRecognition()
            }
        )
    }

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    searchSection

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
                    .onDelete { offsets in
                        pinnedItems.remove(atOffsets: offsets)
                    }
                    .onMove { source, destination in
                        pinnedItems.move(fromOffsets: source, toOffset: destination)
                    }
                }

                Section(header: Text("Mood")) {
                    ForEach(editPinnedViewModel.moodItems, id: \.self) { item in
                        HStack {
                            Image(systemName: "pin.fill")
                                .foregroundStyle(.yellow)
                            Text(item)
                                .onDrag { NSItemProvider(object: item as NSString) }
                        }
                    }
                    .onMove(perform: EditPinnedViewModel.moveMoodItems)
                    .onInsert(of: ["public.txt"], perform: EditPinnedViewModel.dropList2)
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

    private func startSpeechRecognition() {
        do {
            try editPinnedViewModel.startSpeechRecognition { recognitionText in
                searchText = recognitionText
            }
        } catch {
            showError = true
            errorMessage = error.localizedDescription
            isListening = false
        }
    }

    private func stopSpeechRecognition() {
        editPinnedViewModel.stopSpeechRecognition()
    }
}

/*#Preview("Light Mode") {
    @Previewable @State var pinnedItems = ["Mood", "Meditate", "Exercise"]

    return EditPinnedView(pinnedItems: $pinnedItems)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    @Previewable @State var pinnedItems = ["Mood", "Meditate", "Exercise"]

    return EditPinnedView(pinnedItems: $pinnedItems)
        .preferredColorScheme(.dark)
}*/
