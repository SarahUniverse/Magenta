//
//  SelfHelpBooksView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct BooksView: View {
    @StateObject private var booksViewModel = BooksViewModel()

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .brown, location: 0),
            Gradient.Stop(color: .brown.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .brown.opacity(0.3), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        NavigationStack {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Books that Help Me")
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
#Preview("Light Mode") {
    BooksView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    BooksView()
        .preferredColorScheme(.dark)
}
