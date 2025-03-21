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
    @State private var isListening = false
    @State private var showError = false
    @State private var errorMessage = ""
    var summaryViewModel: SummaryViewModel

    init(pinnedItems: Binding<[String]>, summaryViewModel: SummaryViewModel) {
        self._pinnedItems = pinnedItems
        self.summaryViewModel = summaryViewModel
        self._editPinnedViewModel = StateObject(wrappedValue: EditPinnedViewModel(initialPinnedItems: pinnedItems.wrappedValue))
    }

    private var searchSection: some View {
        SearchView(
            text: $editPinnedViewModel.searchText,
            isListening: $isListening,
            startListening: {
                startSpeechRecognition()
            },
            stopListening: {
                editPinnedViewModel.stopSpeechRecognition()
            }
        )
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            searchSection
            List {
                Section(header: Text("Pinned")) {
                    ForEach(editPinnedViewModel.filteredPinnedItems, id: \.self) { item in
                        HStack {
                            Image(systemName: "pin.slash.fill")
                                .foregroundStyle(.red)
                            Text(item)
                                .onDrag { NSItemProvider(object: item as NSString) }
                            Spacer()
                            Image(systemName: "line.3.horizontal")
                                .foregroundStyle(.gray)
                        }
                        .contentShape(Rectangle()) // Makes the entire row tappable
                        .onTapGesture {
                            withAnimation {
                                editPinnedViewModel.unpinItem(item)
                            }
                        }
                    }
                    .onDelete { offsets in
                        let itemsToRemove = offsets.map { editPinnedViewModel.filteredPinnedItems[$0] }
                        itemsToRemove.forEach { item in
                            if let index = editPinnedViewModel.pinnedItems.firstIndex(of: item) {
                                editPinnedViewModel.pinnedItems.remove(at: index)
                                editPinnedViewModel.unpinnedItems.append(item)
                            }
                        }
                    }
                    .onMove { source, destination in
                        editPinnedViewModel.movePinnedItems(from: source, to: destination)
                    }
                }

                Section(header: Text("Unpinned")) {
                    ForEach(editPinnedViewModel.filteredUnpinnedItems, id: \.self) { item in
                        HStack {
                            Image(systemName: "pin.fill")
                                .foregroundStyle(.yellow)
                            Text(item)
                                .onDrag { NSItemProvider(object: item as NSString) }
                        }
                        .contentShape(Rectangle()) // Makes the entire row tappable
                        .onTapGesture {
                            withAnimation {
                                editPinnedViewModel.pinItem(item)
                            }
                        }
                    }
                    .onMove { source, destination in
                        editPinnedViewModel.moveUnpinnedItems(from: source, to: destination)
                    }
                    .onInsert(of: ["public.text"]) { index, providers in
                        editPinnedViewModel.dropList2(at: index, providers)
                    }
                }
            }
            .navigationTitle("Edit Pinned")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        updatePinnedItems()
                        summaryViewModel.savePinnedItems()
                        dismiss()
                    }
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

    // MARK: Private Functions
    private func startSpeechRecognition() {
        do {
            try editPinnedViewModel.startSpeechRecognition { recognitionText in
                editPinnedViewModel.searchText = recognitionText
            }
        } catch {
            showError = true
            errorMessage = error.localizedDescription
            isListening = false
        }
    }

    private func updatePinnedItems() {
        pinnedItems = editPinnedViewModel.pinnedItems
    }
}

// MARK: Previews
#Preview("Light Mode") {
    struct PreviewWrapper: View {
        @State private var pinnedItems = ["Mood", "Meditate", "Exercise"]
        @State private var summaryViewModel: SummaryViewModel

        init() {
            let context = PreviewPersistenceController.preview.container.viewContext
            _summaryViewModel = State(wrappedValue: SummaryViewModel(viewContext: context, colorScheme: .light))
        }

        var body: some View {
            EditPinnedView(pinnedItems: $pinnedItems, summaryViewModel: summaryViewModel)
        }
    }

    return PreviewWrapper()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    struct PreviewWrapper: View {
        @State private var pinnedItems = ["Mood", "Meditate", "Exercise"]
        @State private var summaryViewModel: SummaryViewModel

        init() {
            let context = PreviewPersistenceController.preview.container.viewContext
            _summaryViewModel = State(wrappedValue: SummaryViewModel(viewContext: context, colorScheme: .dark))
        }

        var body: some View {
            EditPinnedView(pinnedItems: $pinnedItems, summaryViewModel: summaryViewModel)
        }
    }

    return PreviewWrapper()
        .preferredColorScheme(.dark)
}
