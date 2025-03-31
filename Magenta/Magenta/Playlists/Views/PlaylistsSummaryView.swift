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
    @Environment(\.colorScheme) private var colorScheme

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _playlistsViewModel = State(wrappedValue: PlaylistsViewModel(viewContext: viewContext))
    }

    private let musicalNotesGradient = LinearGradient(
        gradient: Gradient(colors: [.purple, .blue]),
        startPoint: .topTrailing,
        endPoint: .bottomLeading
    )

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
                        .foregroundStyle(musicalNotesGradient)
                        .font(.system(size: 50))
                    navigationChevron
                }
                .padding()
                .background(glassBackground)
                .cornerRadius(10)
            }
        }
    }

    private var headerText: some View {
        Text("MUSIC")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.gray)
            .padding(.leading, 5)
            .padding(.bottom, -5)
    }

    private var navigationChevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .padding(.bottom, 70)
    }

    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(colorScheme == .dark ? 0.3 : 0.5),
                                .white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        .black.opacity(0.1),
                        lineWidth: 1
                    )
                    .blur(radius: 1)
                    .mask(RoundedRectangle(cornerRadius: 15).fill(.black))
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
