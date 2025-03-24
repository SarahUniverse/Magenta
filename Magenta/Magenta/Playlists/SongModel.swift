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

    init(from song: SongEntity) {
        self.id = song.id ?? UUID()
        self.title = song.title ?? ""
        self.artist = song.artist ?? ""
    }

    init(from mockSong: MockSong) {
        self.id = UUID()
        self.title = mockSong.title
        self.artist = mockSong.artistName
    }

    func toCoreData(context: NSManagedObjectContext) -> SongEntity {
        let song = SongEntity(context: context)
        song.id = self.id
        song.title = self.title
        song.artist = self.artist
        return song
    }

}
