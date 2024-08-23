//
//  MoodView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MoodView: View {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .accent
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Mood")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
        }
    }
}

#Preview {
    MoodView()
}
