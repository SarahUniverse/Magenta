//
//  EditPinnedView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/23/24.
//

import SwiftUI

struct EditPinnedView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var editPinnedViewModel = EditPinnedViewModel()
    @StateObject private var speechRecognizer = SpeechRecognizer()

    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $editPinnedViewModel.searchText)

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
                    editPinnedViewModel.searchText = transcribedText
                }

                Section(header: Text("Pinned")) {
                    ForEach(editPinnedViewModel.pinnedItems, id: \.self) { item in
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
                    .onDelete(perform: editPinnedViewModel.deleteItem)
                    .onMove(perform: editPinnedViewModel.movePinnedItems)
                    .onInsert(of: ["public.txt"], perform: editPinnedViewModel.dropList1)
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
                    .onMove(perform: editPinnedViewModel.moveMoodItems)
                    .onInsert(of: ["public.txt"], perform: editPinnedViewModel.dropList2)
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
    EditPinnedView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    EditPinnedView()
        .preferredColorScheme(.dark)
}
