//
//  QuotesView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct QuotesView: View {
    @StateObject private var quotesViewModel = QuotesViewModel()

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray, location: 0),
            Gradient.Stop(color: .yellow.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .yellow.opacity(0.7), location: 0.2),
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
            .navigationTitle("Helpful Quotes")
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
    QuotesView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    QuotesView()
        .preferredColorScheme(.dark)
}
