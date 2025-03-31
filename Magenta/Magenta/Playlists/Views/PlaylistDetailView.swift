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
    @State private var currentSong: SongModel?

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

    private let playButtonGradient = LinearGradient(
        gradient: Gradient(colors: [.purple, .blue]),
        startPoint: .topTrailing,
        endPoint: .bottomLeading
    )

    private let player = SystemMusicPlayer.shared

    var body: some View {
        NavigationStack {
            songList
        }
        .navigationTitle(playlist.name)
        .background(backgroundGradient)
        .scrollContentBackground(.hidden)
        .onAppear {
            Task {
                await requestMusicAuthorization()
            }
        }
    }

    private var songList: some View {
        List {
            if let songs = playlist.songs, !songs.isEmpty {
                songsSection
            } else {
                emptyPlaylistText
            }
        }
    }

    private var songsSection: some View {
        Section(header: sectionHeader) {
            ForEach(playlist.songs ?? [], id: \.id) { song in
                songRow(for: song)
            }
        }
    }

    private var sectionHeader: some View {
        Text("Songs")
            .foregroundStyle(.white)
            .bold()
    }

    private func songRow(for song: SongModel) -> some View {
        HStack {
            songInfo(for: song)
            Spacer()
            // TODO: Temporary for testing, remove when you have an Apple Music subscription
            //if song.musicKitID != nil {
                playButton(for: song)
            //}
        }
    }

    private func songInfo(for song: SongModel) -> some View {
        VStack(alignment: .leading) {
            Text(song.title)
                .font(.headline)
            Text(song.artist)
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
    }

    private func playButton(for song: SongModel) -> some View {
        Button(action: {
            Task {
                await playSong(song)
            }
        }, label: {
            Image(systemName: isPlaying && currentSong?.id == song.id ? "pause.circle" : "play.circle")
                .font(.system(size: 30))
                .foregroundStyle(playButtonGradient)
        })
    }

    private var emptyPlaylistText: some View {
        Text("No songs in this playlist.")
            .foregroundStyle(.gray)
            .italic()
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

    private func playSong(_ song: SongModel) async {
        guard let musicKitID = song.musicKitID else {
            print("No MusicKit ID available for this song")
            return
        }

        do {
            if currentSong?.id == song.id && isPlaying {
                player.pause()
                isPlaying = false
                return
            }

            // swiftlint: disable force_cast
            let musicSong: MusicKit.Song = try Song(from: musicKitID as! Decoder)
            // swiftlint: enable force_cast

            player.queue = SystemMusicPlayer.Queue(for: [musicSong])

            try await player.prepareToPlay()
            try await player.play()

            currentSong = song
            isPlaying = true
        } catch {
            print("Error playing song: \(error.localizedDescription)")
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
