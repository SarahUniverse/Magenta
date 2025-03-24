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
                    Text(playlist.name)
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
                playlistsViewModel.fetchPlaylists()
            }
            .sheet(isPresented: $showingCreatePlaylist) {
                CreatePlaylistView(playlistsViewModel: playlistsViewModel)
            }
        }
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
    return  PlaylistsView(viewContext: viewContext)
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
    return  PlaylistsView(viewContext: viewContext)
        .preferredColorScheme(.dark)
}
