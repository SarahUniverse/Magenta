//
//  ArtTherapyView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct ArtTherapyView: View {

    // TODO: Update UI and add ArtTherapyViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Art Therapy")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            List {
                Text("hello world")
            }
        }
    }
}

// MARK: Previews
#Preview("Light Mode") {
    ArtTherapyView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ArtTherapyView()
        .preferredColorScheme(.dark)
}
