//
//  PlaylistsModel.swift
//  Magenta
//
//  Created by Sarah Clark on 3/23/25.
//

import Foundation
import MusicKit

struct PlaylistModel: Identifiable, Hashable {
    let id: UUID
    let name: String
    let createdAt: Date
    var songs: [SongModel]?

    init(from playlist: PlaylistEntity) {
        self.id = playlist.id
        self.name = playlist.name
        self.createdAt = playlist.createdAt
        if let songsSet = playlist.songs as? Set<Song> {
            self.songs = songsSet.map { SongModel(from: $0) }
        }
    }

    init(from musicKitPlaylist: MusicKit.Playlist) {
        self.id = UUID()
        self.name = musicKitPlaylist.name
        self.createdAt = Date()
        self.songs = musicKitPlaylist.tracks?.map { SongModel(from: $0) }
    }


    func toCoreData(context: NSManagedObjectContext) -> Playlist {
        let playlist = Playlist(context: context)
        playlist.id = self.id
        playlist.name = self.name
        playlist.createdAt = self.createdAt
        if let songs = self.songs {
            let songEntities = songs.map { $0.toCoreData(context: context) }
            playlist.addToSongs(NSSet(array: songEntities))
        }
        return playlist
    }
}
