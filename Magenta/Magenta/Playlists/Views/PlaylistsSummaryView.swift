//
//  PlaylistsSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData
import SwiftUI

struct PlaylistsSummaryView: View {
    @State private var playlistsViewModel: PlaylistsViewModel
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _playlistsViewModel = State(wrappedValue: PlaylistsViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: PlaylistsView(viewContext: viewContext)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("MUSIC")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "music.note.list")
                        .foregroundStyle(.hotPink)
                        .font(.largeTitle)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                            .font(.subheadline)
                            .foregroundStyle(.white)

                        Button("Review") { }
                            .foregroundStyle(.blue)
                    }
                }
                .padding()
                .background(Color.almostBlack)
                .cornerRadius(10)
            }
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    PlaylistsSummaryViewPreviews.buildPreview(with: MockPlaylist.mockPlaylists)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    PlaylistsSummaryViewPreviews.buildPreview(with: MockPlaylist.mockPlaylists)
        .preferredColorScheme(.dark)
}

struct PlaylistsSummaryViewPreviews {
    static func buildPreview(with mockData: [MockPlaylist]) -> some View {
        let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "DataModel")
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            container.loadPersistentStores { (_, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()

        let viewContext = persistentContainer.viewContext

        for mockPlaylist in mockData {
            let playlistModel = PlaylistModel(from: mockPlaylist)
            _ = playlistModel.toCoreData(context: viewContext)
        }

        return PlaylistsSummaryView(viewContext: viewContext)
    }
}
