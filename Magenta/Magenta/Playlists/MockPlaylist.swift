//
//  MockPlaylist.swift
//  Magenta
//
//  Created by Sarah Clark on 3/23/25.
//

import Foundation
import MusicKit // Add this to use MusicItemID if needed

struct MockPlaylist {
    let id: String
    let name: String
    let curatorName: String?
    let description: String?
    let lastModifiedDate: Date?
    let tracks: [MockSong]

    static var mockPlaylists: [MockPlaylist] {
        let songs1 = [
            MockSong(
                id: "1",
                title: "Breathe",
                artistName: "Taylor Swift",
                albumName: "Evermore",
                duration: 200,
                trackNumber: 1,
                musicKitID: "1544495216"
            ),
            MockSong(
                id: "2",
                title: "Calm Down",
                artistName: "Rema",
                albumName: "Rave & Roses",
                duration: 180,
                trackNumber: 2,
                musicKitID: "1606991138"
            ),
            MockSong(
                id: "3",
                title: "Let It Be",
                artistName: "The Beatles",
                albumName: "Let It Be",
                duration: 243,
                trackNumber: 3,
                musicKitID: "1441164423"
            )
        ]

        let songs2 = [
            MockSong(
                id: "4",
                title: "Happy",
                artistName: "Pharrell Williams",
                albumName: "Despicable Me 2",
                duration: 232,
                trackNumber: 1,
                musicKitID: "1440884419"
            ),
            MockSong(
                id: "5",
                title: "Good Vibrations",
                artistName: "The Beach Boys",
                albumName: "Smiley Smile",
                duration: 216,
                trackNumber: 2,
                musicKitID: "1441168568"
            ),
            MockSong(
                id: "6",
                title: "Walking on Sunshine",
                artistName: "Katrina and The Waves",
                albumName: "Katrina and The Waves",
                duration: 240,
                trackNumber: 3,
                musicKitID: "1441168568"
            )
        ]

        let songs3 = [
            MockSong(
                id: "7",
                title: "Fix You",
                artistName: "Coldplay",
                albumName: "X&Y",
                duration: 294,
                trackNumber: 1,
                musicKitID: "1441168568"
            ),
            MockSong(
                id: "8",
                title: "Hallelujah",
                artistName: "Leonard Cohen",
                albumName: "Various Positions",
                duration: 270,
                trackNumber: 2,
                musicKitID: "1441168568"
            ),
            MockSong(
                id: "9",
                title: "Somewhere Only We Know",
                artistName: "Keane",
                albumName: "Hopes and Fears",
                duration: 237,
                trackNumber: 3,
                musicKitID: "1441168568"
            )
        ]

        return [
            MockPlaylist(
                id: "p1",
                name: "Calm & Reflective",
                curatorName: "Apple Music Wellness",
                description: "Soothing tracks to help you unwind and reflect.",
                lastModifiedDate: Date(),
                tracks: songs1
            ),
            MockPlaylist(
                id: "p2",
                name: "Uplifting Beats",
                curatorName: "Apple Music Pop",
                description: "Feel-good songs to lift your spirits.",
                lastModifiedDate: Date(),
                tracks: songs2
            ),
            MockPlaylist(
                id: "p3",
                name: "Healing Melodies",
                curatorName: "Apple Music Alternative",
                description: "Melodies to comfort and heal the soul.",
                lastModifiedDate: Date(),
                tracks: songs3
            )
        ]
    }
}

struct MockSong {
    let id: String
    let title: String
    let artistName: String
    let albumName: String?
    let duration: TimeInterval?
    let trackNumber: Int?
    let musicKitID: String?
}
