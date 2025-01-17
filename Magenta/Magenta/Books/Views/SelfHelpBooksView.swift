//
//  SelfHelpBooksView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct SelfHelpBooksView: View {

    var body: some View {
        NavigationStack {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Self Help Books")
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
#Preview("Light Mode") {
    SelfHelpBooksView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    SelfHelpBooksView()
        .preferredColorScheme(.dark)
}
