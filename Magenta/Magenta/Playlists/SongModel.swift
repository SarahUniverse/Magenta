//
//  SongModel.swift
//  Magenta
//
//  Created by Sarah Clark on 3/23/25.
//

import CoreData
import MusicKit

struct SongModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let artist: String
    let album: String?
    let duration: TimeInterval?
    let trackNumber: Int?
    let musicKitID: MusicItemID?

    init(from mockSong: MockSong) {
        self.id = UUID()
        self.title = mockSong.title
        self.artist = mockSong.artistName
        self.album = mockSong.albumName
        self.duration = mockSong.duration
        self.trackNumber = mockSong.trackNumber
        self.musicKitID = mockSong.musicKitID.map { MusicItemID($0) }
    }

    init(from songEntity: SongEntity) {
        self.id = songEntity.id ?? UUID()
        self.title = songEntity.title ?? ""
        self.artist = songEntity.artist ?? ""
        self.album = songEntity.album
        self.duration = songEntity.duration
        self.trackNumber = Int(songEntity.trackNumber)
        self.musicKitID = songEntity.musicKitID.map { MusicItemID($0) }
    }

    func toCoreData(context: NSManagedObjectContext) -> SongEntity {
        let songEntity = SongEntity(context: context)
        songEntity.id = self.id
        songEntity.title = self.title
        songEntity.artist = self.artist
        songEntity.album = self.album
        songEntity.duration = self.duration ?? 0
        songEntity.trackNumber = Int16(self.trackNumber ?? 0)
        songEntity.musicKitID = self.musicKitID?.rawValue
        return songEntity
    }

}
