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

    // MARK: Gradients
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

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            playlistGrid
                .navigationTitle("My Playlists")
                .background(AppGradients.backgroundGradient)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingCreatePlaylist = true
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.white, .indigo)
                                .shadow(radius: 5, y: 3)
                        })
                    }
                }
                .onAppear {
                    playlistsViewModel.fetchPlaylistsFromCoreData()
#if DEBUG
                    // playlistsViewModel.deleteAllPlaylists() // Uncomment during debugging if you want to use.
#endif
                }
                .sheet(isPresented: $showingCreatePlaylist) {
                    CreatePlaylistView(playlistsViewModel: playlistsViewModel)
                }
        }
    }

    private var mostRecentPlaylistModel: PlaylistModel? {
        playlistsViewModel.fetchMostRecentPlaylist()
    }

    private var mostRecentPlaylist: some View {
        Group {
            if let playlist = mostRecentPlaylistModel {
                NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(mostRecentPlaylistGradient)
                            .frame(width: 350, height: 100)
                            .shadow(radius: 5, y: 3)
                        HStack(alignment: .center) {
                            VStack {
                                Text("Most Recent:")
                                    .font(.callout)
                                    .foregroundStyle(.white.opacity(0.8))
                                    .bold()
                                    .padding(.bottom, 5)
                                Text(playlist.name)
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    .bold()
                                    .lineLimit(1)
                            }
                            Image(systemName: "music.quarternote.3")
                                .font(.system(size: 40))
                                .foregroundStyle(.white.opacity(0.2))
                                .padding(.leading, 20)
                        }
                        .padding()
                    }
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(mostRecentPlaylistGradient)
                        .frame(width: 350, height: 100)
                        .shadow(radius: 5, y: 3)
                    Text("No playlists yet")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .bold()
                }
            }
        }
    }

    private var playlistGrid: some View {
        ScrollView {
            mostRecentPlaylist
                .padding(.top, 20)
                .padding(.bottom, 20)
            Divider()
                .background(.hotPink)
                .padding(.horizontal)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(playlistsViewModel.playlists, id: \.self) { playlist in
                    playlistNavigationLink(playlist: playlist)
                }
            }
            .padding()
        }
    }

    // MARK: Functions
    func deletePlaylist(at offsets: IndexSet) {
        for index in offsets {
            let playlistToDelete = playlistsViewModel.playlists[index]
            playlistsViewModel.deletePlaylist(playlist: playlistToDelete)
        }
    }

    // MARK: - Private Functions
    private func playlistNavigationLink(playlist: PlaylistModel) -> some View {
        NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
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
