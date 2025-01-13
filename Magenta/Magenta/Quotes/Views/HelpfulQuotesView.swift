//
//  HelpfulQuotesView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct HelpfulQuotesView: View {

    var body: some View {
        NavigationView {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Helpful Quotes")
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
    HelpfulQuotesView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    HelpfulQuotesView()
        .preferredColorScheme(.dark)
}
