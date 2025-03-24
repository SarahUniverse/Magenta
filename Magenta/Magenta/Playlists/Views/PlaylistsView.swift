//
//  MentalHealthPlaylists.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import MusicKit
import SwiftUI

struct PlaylistsView: View {
    @State private var playlistsViewModel: PlaylistsViewModel
    let viewContext: NSManagedObjectContext
    @State private var showingCreatePlaylist = false

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _playlistsViewModel = State(wrappedValue: PlaylistsViewModel(viewContext: viewContext))
    }

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .hotPink, location: 0),
            Gradient.Stop(color: .hotPink.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .hotPink.opacity(0.3), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        NavigationStack {
            List {
                ForEach(playlistsViewModel.playlists, id: \.self) { playlist in
                    Section(header: Text(playlist.name)) {
                        if let songs = playlist.songs, !songs.isEmpty {
                            ForEach(songs) { song in
                                VStack(alignment: .leading) {
                                    Text(song.title)
                                        .font(.headline)
                                    Text(song.artist)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .onDelete(perform: deletePlaylist)
                        } else {
                            Text("No songs in this playlist")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Mental Health Playlists")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreatePlaylist = true
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.hotPink, .blue)
                    })
                }
            }
            .onAppear {
                playlistsViewModel.fetchPlaylistsFromCoreData()
                // playlistsViewModel.deleteAllPlaylists() // Uncomment during debugging if you want to use.
            }
            .sheet(isPresented: $showingCreatePlaylist) {
                CreatePlaylistView(playlistsViewModel: playlistsViewModel)
            }
        }
    }

    func deletePlaylist(at offsets: IndexSet) {
        for index in offsets {
            let playlistToDelete = playlistsViewModel.playlists[index]
            playlistsViewModel.deletePlaylist(playlist: playlistToDelete)
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    PlaylistsViewPreviews.buildPreview(with: MockPlaylist.mockPlaylists)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    PlaylistsViewPreviews.buildPreview(with: MockPlaylist.mockPlaylists)
        .preferredColorScheme(.dark)
}

struct PlaylistsViewPreviews {
    static func buildPreview(with mockData: [MockPlaylist]) -> some View {
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

        for mockPlaylist in mockData {
            let playlistModel = PlaylistModel(from: mockPlaylist)
            _ = playlistModel.toCoreData(context: viewContext)
        }

        return PlaylistsView(viewContext: viewContext)
    }
}
