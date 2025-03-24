//
//  PlaylistsViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData
import MusicKit

@Observable final class PlaylistsViewModel {
    let viewContext: NSManagedObjectContext
    var playlists: [Playlist] = []
    var authorizationStatus: MusicAuthorization.Status = .notDetermined

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
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

                // Save to CoreData
                for mkPlaylist in musicKitPlaylists {
                    let playlistModel = PlaylistModel(from: mkPlaylist)
                    let playlist = playlistModel.toCoreData(context: viewContext)
                    // Save to CoreData
                }
                try viewContext.save()
                fetchPlaylists() // Refresh the list
            } catch {
                print("Failed to fetch MusicKit playlists: \(error)")
            }
        }
    }

    func createPlaylist(name: String) {
        let newPlaylist = Playlist(context: viewContext)
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

    // MARK: Private Functions
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

}
