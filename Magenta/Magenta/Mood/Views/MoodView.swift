//
//  MoodView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MoodView: View {
    @StateObject private var moodViewModel = MoodViewModel()

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .yellow, location: 0),
            Gradient.Stop(color: .yellow.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .blue.opacity(0.7), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        NavigationStack {
            List(moodViewModel.items, id: \.self) { item in
                Text(item)
            }
            .navigationTitle("What's My Mood?")
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

// MARK: - Previews
#Preview ("Light Mode") {
    MoodView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    MoodView()
        .preferredColorScheme(.dark)
}
