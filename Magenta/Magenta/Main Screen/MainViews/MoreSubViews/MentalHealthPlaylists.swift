//
//  MentalHealthPlaylists.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct MentalHealthPlaylists: View {

    var body: some View {
        NavigationView {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Mental Health Playlists")
            .toolbarBackground(.purple2, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
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
    MentalHealthPlaylists()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    MentalHealthPlaylists()
        .preferredColorScheme(.dark)
}
