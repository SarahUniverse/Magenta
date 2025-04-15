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
                headerText

                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        if let mostRecentPlaylist = playlistsViewModel.fetchMostRecentPlaylist() {
                            Text("Most Recent Playlist:")
                                .font(.callout)
                                .foregroundStyle(.gray)
                                .bold()
                                .padding(.bottom, 5)
                            Text(mostRecentPlaylist.name)
                                .font(.title3)
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        } else {
                            Text("No playlists yet")
                                .font(.subheadline)
                                .foregroundStyle(.gray)

                                .italic()
                        }
                    }
                    Spacer()
                    Image(systemName: "music.quarternote.3")
                        .foregroundStyle(AppGradients.summaryIconGradient)
                        .font(.system(size: 50))
                    Spacer()
                    NavigationChevron()
                }
                .padding(25)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(GlassBackground())
            }
        }
    }

    private var headerText: some View {
        Text("MUSIC")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(Color(UIColor.secondaryLabel))
            .padding(.leading, 5)
            .padding(.bottom, -20)
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
