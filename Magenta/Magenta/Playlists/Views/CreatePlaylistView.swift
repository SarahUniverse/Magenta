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

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Playlist")) {
                    TextField("Playlist Name", text: $playlistName)
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
