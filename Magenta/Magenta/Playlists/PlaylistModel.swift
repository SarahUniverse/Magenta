//
//  PlaylistsModel.swift
//  Magenta
//
//  Created by Sarah Clark on 3/23/25.
//

import CoreData
import Foundation
import MusicKit

struct PlaylistModel: Identifiable, Hashable {
    let id: UUID
    let name: String
    let createdAt: Date
    var songs: [SongModel]?

    init(from playlist: PlaylistEntity) {
        self.id = playlist.id ?? UUID()
        self.name = playlist.name ?? ""
        self.createdAt = playlist.createdAt ?? Date()
        if let songsSet = playlist.songs as? Set<SongEntity> {
            self.songs = songsSet.map { SongModel(from: $0) }.sorted { $0.title < $1.title }
        } else {
            self.songs = nil
        }
    }

    init(from mockPlaylist: MockPlaylist) {
        self.id = UUID()
        self.name = mockPlaylist.name
        self.createdAt = mockPlaylist.lastModifiedDate ?? Date()
        self.songs = mockPlaylist.tracks.map { SongModel(from: $0) }
    }

    func toCoreData(context: NSManagedObjectContext) -> PlaylistEntity {
        let playlist = PlaylistEntity(context: context)
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
