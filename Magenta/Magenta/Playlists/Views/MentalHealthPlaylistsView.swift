//
//  MentalHealthPlaylists.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct MentalHealthPlaylistsView: View {

    var body: some View {
        NavigationView {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Mental Health Playlists")
            .toolbarBackground(.darkBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
        }
    }
}

// MARK: Previews
#Preview("Light Mode") {
    MentalHealthPlaylistsView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    MentalHealthPlaylistsView()
        .preferredColorScheme(.dark)
}
