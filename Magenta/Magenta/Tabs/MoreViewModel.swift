//
//  MoreViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/8/25.
//

import SwiftUI

final class MoreViewModel: ObservableObject {
    @Published var navigationTitle = "More"
    @Published var items: [(icon: String, title: String)] = [
        ("fork.knife", "Nutrition"),
        ("circle.dotted", "Cycle"),
        ("moon.zzz", "Sleep"),
        ("gearshape", "Settings"),
        ("magnifyingglass", "Find a Therapist"),
        ("pencil.and.scribble", "Journal"),
        ("music.note", "Mental Health Playlists"),
        ("book", "Self Help Books"),
        ("quote.bubble", "Helpful Quotes"),
        ("paintpalette", "Art Therapy")
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - Methods
    func handleItemTap(at index: Int) {
        print("\(items[index].title) button tapped")
        // Add navigation or action logic here
    }

    func handleSignOut() {
        // Implement sign out logic here
        print("Sign out tapped")
    }

}
