//
//  MoodView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MoodView: View {
    @StateObject private var moodViewModel = MoodViewModel()

    var body: some View {
        NavigationStack {
            List(moodViewModel.items, id: \.self) { item in
                Text(item)
            }
            .navigationTitle("Mood")
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

// MARK: - Previews
#Preview ("Light Mode") {
    MoodView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    MoodView()
        .preferredColorScheme(.dark)
}
