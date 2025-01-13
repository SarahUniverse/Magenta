//
//  TherapistSearchView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct TherapistSearchView: View {

    var body: some View {
        NavigationView {
            List {
                Text("Hello, World!")
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

// MARK: Previews
#Preview("Light Mode") {
    TherapistSearchView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    TherapistSearchView()
        .preferredColorScheme(.dark)
}
