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
        NavigationView {
            List(moodViewModel.items, id: \.self) { item in
                Text(item)
            }
            .navigationTitle("Mood")
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
    MoodView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    MoodView()
        .preferredColorScheme(.dark)
}
