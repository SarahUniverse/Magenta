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

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _playlistsViewModel = State(wrappedValue: PlaylistsViewModel(viewContext: viewContext))
    }

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray, location: 0),
            Gradient.Stop(color: .gray.opacity(0.6), location: 0.1),
            Gradient.Stop(color: .gray.opacity(0.5), location: 0.2),
            Gradient.Stop(color: .gray.opacity(0.3), location: 0.3)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

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
                                .foregroundStyle(.gray, .hotPink)
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

    private var playlistGrid: some View {
        ScrollView {
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
                .fill(Color.gray)
                .frame(width: 150, height: 150)
            VStack {
                Image(systemName: "music.note.list")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
                Text(playlist.name)
                    .foregroundStyle(.white)
                    //.padding(10)
            }
            .shadow(color: .black.opacity(0.7), radius: 5)
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
