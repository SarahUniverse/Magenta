//
//  MentalHealthPlaylists.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import MusicKit
import SwiftUI

struct PlaylistsView: View {
    @State private var playlistsViewModel: PlaylistsViewModel
    let viewContext: NSManagedObjectContext
    @State private var showingCreatePlaylist = false
    @Environment(\.colorScheme) var colorScheme

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _playlistsViewModel = State(wrappedValue: PlaylistsViewModel(viewContext: viewContext))
    }

    private let mostRecentPlaylistGradient = LinearGradient(
        gradient: Gradient(colors: [.purple, .blue]),
        startPoint: .topTrailing,
        endPoint: .bottomLeading
    )

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .hotPink, location: 0),
            Gradient.Stop(color: .hotPink.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .hotPink.opacity(0.3), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    private var circleGradient: LinearGradient {
        LinearGradient(
            colors: [
                .indigo.opacity(colorScheme == .dark ? 1.0 : 0.6),
                .indigo.opacity(0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        NavigationStack {
            playlistGrid
                .navigationTitle("Mental Health Playlists")
                .background(backgroundGradient)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingCreatePlaylist = true
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.black, .hotPink)
                                .shadow(color: .black, radius: 3)
                        })
                    }
                }
                .onAppear {
                    playlistsViewModel.fetchPlaylistsFromCoreData()
                    // playlistsViewModel.deleteAllPlaylists() // Uncomment during debugging if you want to use.
                }
                .sheet(isPresented: $showingCreatePlaylist) {
                    CreatePlaylistView(playlistsViewModel: playlistsViewModel)
                }
        }
    }

    private var mostRecentPlaylistName: String {
        playlistsViewModel.playlists
            .sorted { $0.createdAt > $1.createdAt }
            .first?.name ?? "No playlists yet"
    }

    private var mostRecentPlaylist: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(mostRecentPlaylistGradient)
                .frame(width: 350, height: 100)
                .shadow(radius: 5, y: 3)
            HStack(alignment: .center) {
                VStack {
                    Text("Most Recent:")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                        .bold()
                        .padding(.bottom, 5)
                    Text(mostRecentPlaylistName)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .bold()
                        .lineLimit(1)
                }
                Image(systemName: "music.note")
                    .font(.system(size: 40))
                    .foregroundStyle(.white.opacity(0.2))
                    .padding(.leading, 20)
            }
            .padding()
        }
    }

    private var playlistGrid: some View {
        ScrollView {
            mostRecentPlaylist
                .padding(.top, 20)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(playlistsViewModel.playlists, id: \.self) { playlist in
                    playlistNavigationLink(playlist: playlist)
                }
            }
            .padding()
        }
    }

    private func playlistNavigationLink(playlist: PlaylistModel) -> some View {
        NavigationLink(destination: PlaylistDetailView()) {
            playlistIcon(playlist: playlist)
        }
    }

    private func playlistIcon(playlist: PlaylistModel) -> some View {
        ZStack {
            Circle()
                .fill(circleGradient)
                .frame(width: 150, height: 150)
                .shadow(radius: 5, y: 3)
            VStack {
                Text(playlist.name)
                    .foregroundStyle(.white.opacity(0.9))
                    .font(.callout)
                    .bold()
                Image(systemName: "music.note.list")
                    .font(.system(size: 60))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(30)
        }
    }

    func deletePlaylist(at offsets: IndexSet) {
        for index in offsets {
            let playlistToDelete = playlistsViewModel.playlists[index]
            playlistsViewModel.deletePlaylist(playlist: playlistToDelete)
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    PlaylistsViewPreviews.buildPreview(with: MockPlaylist.mockPlaylists)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    PlaylistsViewPreviews.buildPreview(with: MockPlaylist.mockPlaylists)
        .preferredColorScheme(.dark)
}

struct PlaylistsViewPreviews {
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

        return PlaylistsView(viewContext: viewContext)
    }
}
