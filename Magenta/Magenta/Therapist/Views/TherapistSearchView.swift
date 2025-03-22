//
//  TherapistSearchView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct TherapistSearchView: View {
    @State private var therapistSearchViewModel = TherapistSearchViewModel()

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .teal, location: 0),
            Gradient.Stop(color: .teal.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .teal.opacity(0.3), location: 0.2),
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
            .navigationTitle("Find a Therapist")
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
    TherapistSearchView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    TherapistSearchView()
        .preferredColorScheme(.dark)
}
