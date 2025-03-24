//
//  PlaylistsViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData
import MusicKit
import SwiftUI

@Observable final class PlaylistsViewModel {
    let viewContext: NSManagedObjectContext
    var playlists: [PlaylistModel] = []
    var authorizationStatus: MusicAuthorization.Status = .notDetermined

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        requestAuthorization()
    }

    private func requestAuthorization() {
        Task {
            let status = await MusicAuthorization.request()
            DispatchQueue.main.async {
                self.authorizationStatus = status
                if status == .authorized {
                    self.fetchMusicKitPlaylists()
                }
            }
        }
    }

    func fetchPlaylists() {
        let request: NSFetchRequest<PlaylistEntity> = PlaylistEntity.fetchRequest()
        do {
            let coreDataPlaylists = try viewContext.fetch(request)
            self.playlists = coreDataPlaylists.map { PlaylistModel(from: $0) }
        } catch {
            print("Failed to fetch playlists: \(error)")
        }
    }

    func fetchMusicKitPlaylists() {
        Task {
            do {
                let request = MusicLibraryRequest<MusicKit.Playlist>()
                let response = try await request.response()
                let musicKitPlaylists = response.items

                for mkPlaylist in musicKitPlaylists {
                    // Fetch tracks asynchronously
                    let tracks = try await fetchTracks(for: mkPlaylist)
                    var playlistModel = PlaylistModel(from: mkPlaylist)
                    playlistModel.songs = tracks
                    let playlist = playlistModel.toCoreData(context: viewContext)
                    if let songs = playlist.songs as? Set<SongEntity> {
                        for song in songs {
                            song.playlist = playlist
                        }
                    }
                }
                try viewContext.save()
                fetchPlaylists()
            } catch {
                print("Failed to fetch MusicKit playlists: \(error)")
            }
        }
    }

    private func fetchTracks(for playlist: MusicKit.Playlist) async throws -> [SongModel] {
        guard let tracks = try await playlist.with([.tracks]).tracks else { return [] }
        return tracks.compactMap { track in
            guard let song = track as? MusicKit.Song else { return nil }
            return SongModel(from: song)
        }
    }

    func createPlaylist(name: String) {
        let newPlaylist = PlaylistEntity(context: viewContext)
        newPlaylist.id = UUID()
        newPlaylist.name = name
        newPlaylist.createdAt = Date()
        do {
            try viewContext.save()
            fetchPlaylists()
        } catch {
            print("Failed to save playlist: \(error)")
        }
    }

}
