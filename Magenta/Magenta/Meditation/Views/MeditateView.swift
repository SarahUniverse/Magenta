//
//  MeditateView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MeditateView: View {
    @StateObject private var viewModel = MeditateViewModel()

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .cyan, location: 0),
            Gradient.Stop(color: .darkBlue.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .darkBlue.opacity(0.7), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        NavigationStack {
            List(viewModel.meditationSessions, id: \.self) { session in
                Text(session)
            }
            .navigationTitle("Meditate")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
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
