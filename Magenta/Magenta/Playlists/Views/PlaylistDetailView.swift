//
//  PlaylistDetailView.swift
//  Magenta
//
//  Created by Sarah Clark on 3/24/25.
//

import CoreData
import MusicKit
import SwiftUI

struct PlaylistDetailView: View {
    let playlist: PlaylistModel
    @State private var isPlaying: Bool = false
    @State private var currentSong: Song?

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

    private let player = SystemMusicPlayer.shared

    var body: some View {
        NavigationStack {
            List {
                if let songs = playlist.songs, !songs.isEmpty {
                    Section(header: Text("Songs").foregroundStyle(.white).bold()) {
                        ForEach(songs, id: \.self) { song in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(song.title)
                                        .font(.headline)
                                    Text(song.artist)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    Task {
                                        await playSong(song)
                                    }
                                }, label: {
                                    Image(systemName: isPlaying && currentSong?.id == song.id ? "pause.circle" : "play.circle")
                                        .font(.title2)
                                        .foregroundStyle(.hotPink)
                                })
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
        .onAppear {
            await requestMusicAuthorization
        }
    }

    // MARK: - Private Functions
    private func requestMusicAuthorization() async {
        let status = await MusicAuthorization.request()
            switch status {
                case .authorized:
                    print("MusicKit authorization granted")
                default:
                    print("MusicKit authorization denied")
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let mockPlaylist = MockPlaylist.mockPlaylists.first!
    let playlistModel = PlaylistModel(from: mockPlaylist)

    return NavigationStack {
        PlaylistDetailView(playlist: playlistModel)
            .preferredColorScheme(.light)
    }
}

#Preview("Dark Mode") {
    let mockPlaylist = MockPlaylist.mockPlaylists.first!
    let playlistModel = PlaylistModel(from: mockPlaylist)

    return NavigationStack {
        PlaylistDetailView(playlist: playlistModel)
            .preferredColorScheme(.dark)
    }
}
