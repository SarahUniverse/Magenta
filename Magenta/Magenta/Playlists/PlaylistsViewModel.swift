//
//  PlaylistsViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData
import MusicKit
import SwiftUI

@MainActor
@Observable final class PlaylistsViewModel {
    let viewContext: NSManagedObjectContext
    var playlists: [PlaylistModel] = []
    var authorizationStatus: MusicAuthorization.Status = .notDetermined
    var availableSongs: [SongModel] = []

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchAvailableSongs()
        requestAuthorization()
    }

    func fetchMostRecentPlaylist() -> PlaylistModel? {
        let request: NSFetchRequest<PlaylistEntity> = PlaylistEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        request.fetchLimit = 1

        do {
            let coreDataPlaylists = try viewContext.fetch(request)
            if let mostRecentEntity = coreDataPlaylists.first {
                return PlaylistModel(from: mostRecentEntity)
            }
            return nil
        } catch {
            print("Failed to fetch most recent playlist: \(error)")
            return nil
        }
    }

    func fetchMockPlaylists() {
        // Use static mock data for now.
        let mockPlaylists = MockPlaylist.mockPlaylists

        for mockPlaylist in mockPlaylists {
            let playlistModel = PlaylistModel(from: mockPlaylist)
            let playlist = playlistModel.toCoreData(context: viewContext)
            if let songs = playlist.songs as? Set<SongEntity> {
                for song in songs {
                    song.playlist = playlist
                }
            }
        }
        do {
            try viewContext.save()
            fetchPlaylistsFromCoreData()
        } catch {
            print("Failed to save playlists: \(error)")
        }
    }

    func fetchPlaylistsFromCoreData() {
        let request: NSFetchRequest<PlaylistEntity> = PlaylistEntity.fetchRequest()
        do {
            let coreDataPlaylists = try viewContext.fetch(request)
            self.playlists = coreDataPlaylists.map { PlaylistModel(from: $0) }
        } catch {
            print("Failed to fetch playlists: \(error)")
        }
    }

    func deletePlaylist(playlist: PlaylistModel) {
        guard let playlistEntity = fetchPlaylistEntity(withId: playlist.id) else { return }
        viewContext.delete(playlistEntity)

        do {
            try viewContext.save()
            fetchPlaylistsFromCoreData()
        } catch {
            print("Error deleting playlist: \(error)")
        }
    }

#if DEBUG
    // For testing purposes only.
    func deleteAllPlaylists() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PlaylistEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
            playlists = []
        } catch {
            print("Error deleting all playlists: \(error)")
        }
    }
#endif

    // TODO: Use this code once you have an Apple Music subscription.
    /*func fetchMusicKitPlaylists() {
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
    }*/

    func createPlaylist(name: String, songs: [SongModel] = []) {
        let newPlaylist = PlaylistEntity(context: viewContext)
        newPlaylist.id = UUID()
        newPlaylist.name = name
        newPlaylist.createdAt = Date()

        if !songs.isEmpty {
            let songEntities = songs.map { song in
                let songEntity = SongEntity(context: viewContext)
                songEntity.id = song.id
                songEntity.title = song.title
                songEntity.artist = song.artist
                songEntity.album = song.album
                songEntity.duration = song.duration ?? 0
                songEntity.trackNumber = Int16(song.trackNumber ?? 0)
                songEntity.playlist = newPlaylist
                return songEntity
            }
            newPlaylist.addToSongs(NSSet(array: songEntities))
        }

        do {
            try viewContext.save()
            fetchPlaylistsFromCoreData()
        } catch {
            print("Failed to save playlist: \(error)")
        }
    }

    // MARK: - Private Functions
    private func fetchPlaylistEntity(withId id: UUID) -> PlaylistEntity? {
        let fetchRequest: NSFetchRequest<PlaylistEntity> = PlaylistEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let playlists = try viewContext.fetch(fetchRequest)
            return playlists.first
        } catch {
            print("Error fetching playlist entity: \(error)")
            return nil
        }
    }

    private func requestAuthorization() {
        Task {
            let status = await MusicAuthorization.request()
            self.authorizationStatus = status
            if status == .authorized {
                self.fetchMockPlaylists()
            }
        }
    }

    private func fetchAvailableSongs() {
        let mockPlaylists = MockPlaylist.mockPlaylists
        let allSongs = mockPlaylists.flatMap { $0.tracks }.map { SongModel(from: $0)}
        self.availableSongs = Array(Set(allSongs)).sorted { $0.title < $1.title }
    }

}
