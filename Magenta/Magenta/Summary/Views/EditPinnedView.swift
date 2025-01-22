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
    @StateObject private var viewModel = EditPinnedViewModel()
    @StateObject private var speechRecognizer = SpeechRecognizer()

    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $viewModel.searchText)

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
                    viewModel.searchText = transcribedText
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
                    ForEach(viewModel.moodItems, id: \.self) { item in
                        HStack {
                            Image(systemName: "pin.fill")
                                .foregroundStyle(.yellow)
                            Text(item)
                                .onDrag { NSItemProvider(object: item as NSString) }
                        }
                    }
                    .onMove(perform: viewModel.moveMoodItems)
                    .onInsert(of: ["public.txt"], perform: viewModel.dropList2)
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
}

#Preview("Light Mode") {
    @Previewable @State var pinnedItems = ["Mood", "Meditate", "Exercise"]

    return EditPinnedView(pinnedItems: $pinnedItems)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    @Previewable @State var pinnedItems = ["Mood", "Meditate", "Exercise"]

    return EditPinnedView(pinnedItems: $pinnedItems)
        .preferredColorScheme(.dark)
}
