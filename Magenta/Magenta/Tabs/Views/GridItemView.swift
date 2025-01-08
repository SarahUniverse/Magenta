//
//  GridItemView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/8/25.
//

import SwiftUI

struct GridItemView: View {
    let icon: String
    let title: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.mediumBlue)
            Text(title)
                .bold()
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .cornerRadius(10)
    }
}

#Preview ("Light Mode") {
    GridItemView(icon: "figure.run", title: "Exercise")
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    GridItemView(icon: "figure.run", title: "Exercise")
        .preferredColorScheme(.dark)
}
