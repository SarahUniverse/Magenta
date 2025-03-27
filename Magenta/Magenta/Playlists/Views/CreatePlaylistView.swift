//
//  CreatePlaylistView.swift
//  Magenta
//
//  Created by Sarah Clark on 3/23/25.
//

import CoreData
import SwiftUI

struct CreatePlaylistView: View {
    @Environment(\.dismiss) var dismiss
    var playlistsViewModel: PlaylistsViewModel
    @State private var playlistName = ""
    @State private var selectedSongs: Set<SongModel> = [] // Track selected songs.
    @State private var searchText = ""

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .indigo, location: 0),
            Gradient.Stop(color: .indigo.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .indigo.opacity(0.3), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    private var filteredSongs: [SongModel] {
        if searchText.isEmpty {
            return playlistsViewModel.availableSongs
        } else {
            return playlistsViewModel.availableSongs.filter { song in
                song.title.lowercased().contains(searchText.lowercased()) ||
                song.artist.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Playlist")) {
                    TextField("Playlist Name", text: $playlistName)
                }

                Section(header: Text("Add Songs")) {

                    TextField("Search Songs", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.vertical, 5)

                    if filteredSongs.isEmpty {
                        Text(searchText.isEmpty ? "No songs available to add." : "No songs match your search.")
                            .foregroundStyle(.gray)
                    } else {
                        List(filteredSongs, id: \.self) { song in
                            Toggle(isOn: Binding(
                                get: { selectedSongs.contains(song) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedSongs.insert(song)
                                    } else {
                                        selectedSongs.remove(song)
                                    }
                                }
                            )) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(song.title)
                                            .font(.headline)
                                        Text(song.artist)
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Create Playlist")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.red)
                    .shadow(radius: 5, y: 3)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        playlistsViewModel.createPlaylist(name: playlistName)
                        dismiss()
                    }
                    .foregroundStyle(.white)
                    .shadow(radius: 5, y: 3)
                    .disabled(playlistName.isEmpty)
                }
            }
        }
    }

}

#Preview("Light Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    let viewContext = persistentContainer.viewContext
    let playlistsViewModel = PlaylistsViewModel(viewContext: viewContext)
    return CreatePlaylistView(playlistsViewModel: playlistsViewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    let viewContext = persistentContainer.viewContext
    let playlistsViewModel = PlaylistsViewModel(viewContext: viewContext)
    return CreatePlaylistView(playlistsViewModel: playlistsViewModel)
        .preferredColorScheme(.dark)
}
