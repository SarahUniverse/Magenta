//
//  ArtTherapyView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct ArtTherapyView: View {
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
            .navigationTitle("Art Therapy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
        }
    }
}

#Preview {
    ArtTherapyView()
}
