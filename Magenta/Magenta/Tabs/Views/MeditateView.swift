//
//  MeditateView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MeditateView: View {
    @StateObject private var viewModel = MeditateViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.meditationSessions, id: \.self) { session in
                Text(session)
            }
            .navigationTitle("Meditate")
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

#Preview ("Light Mode") {
    MeditateView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    MeditateView()
        .preferredColorScheme(.dark)
}
