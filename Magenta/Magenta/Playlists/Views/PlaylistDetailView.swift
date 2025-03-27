//
//  PlaylistDetailView.swift
//  Magenta
//
//  Created by Sarah Clark on 3/24/25.
//

import CoreData
import SwiftUI

struct PlaylistDetailView: View {
    var playlistsViewModel: PlaylistsViewModel
    let playlist: PlaylistModel

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
                if let songs = playlist.songs, !songs.isEmpty {
                    Section(header: Text("Songs")) {
                        ForEach(songs, id: \.self) { song in
                            VStack(alignment: .leading) {
                                Text(song.title)
                                    .font(.headline)
                                Text(song.artist)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                } else {
                    Text("No songs in this playlist.")
                        .foregroundStyle(.gray)
                        .italic()
                }
            }
        }
        .navigationTitle(playlist.name)
        .background(backgroundGradient)
        .scrollContentBackground(.hidden)
    }
}

// MARK: - Previews
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
    let mockPlaylist = MockPlaylist.mockPlaylists.first!
    let playlistModel = PlaylistModel(from: mockPlaylist)

    return PlaylistDetailView(playlistsViewModel: playlistsViewModel, playlist: playlistModel)
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
    let mockPlaylist = MockPlaylist.mockPlaylists.first!
    let playlistModel = PlaylistModel(from: mockPlaylist)

    return PlaylistDetailView(playlistsViewModel: playlistsViewModel, playlist: playlistModel)
        .preferredColorScheme(.dark)
}
