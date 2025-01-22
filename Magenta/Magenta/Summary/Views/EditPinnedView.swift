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

    init(pinnedItems: Binding<[String]>) {
        self._pinnedItems = pinnedItems
        // Initialize StateObject with proper initialization
        self._editPinnedViewModel = StateObject(wrappedValue: EditPinnedViewModel())
    }

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
                searchSection

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
                    .onMove { source, destination in
                        editPinnedViewModel.moveMoodItems(from: source, to: destination)
                    }
                    .onInsert(of: ["public.txt"]) { index, providers in
                        editPinnedViewModel.dropList2(at: index, providers)
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
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
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
}

#Preview("Light Mode") {
    struct PreviewWrapper: View {
        @State private var pinnedItems = ["Mood", "Meditate", "Exercise"]

        var body: some View {
            EditPinnedView(pinnedItems: $pinnedItems)
        }
    }

    return PreviewWrapper()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    struct PreviewWrapper: View {
        @State private var pinnedItems = ["Mood", "Meditate", "Exercise"]

        var body: some View {
            EditPinnedView(pinnedItems: $pinnedItems)
        }
    }

    return PreviewWrapper()
        .preferredColorScheme(.dark)
}
