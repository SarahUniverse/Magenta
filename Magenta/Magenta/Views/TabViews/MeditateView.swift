//
//  MeditateView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MeditateView: View {

    var body: some View {
        NavigationView {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Meditate")
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

#Preview {
    MeditateView()
}
