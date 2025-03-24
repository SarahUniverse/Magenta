//
//  CreatePlaylistView.swift
//  Magenta
//
//  Created by Sarah Clark on 3/23/25.
//

import SwiftUI

struct CreatePlaylistView: View {
    @Environment(\.dismiss) var dismiss
    var playlistsViewModel: PlaylistsViewModel
    @State private var playlistName = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Playlist")) {
                    TextField("Playlist Name", text: $playlistName)
                }
            }
            .navigationTitle("Create Playlist")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        playlistsViewModel.createPlaylist(name: playlistName)
                        dismiss()
                    }
                    .disabled(playlistName.isEmpty)
                }
            }
        }
    }

}
