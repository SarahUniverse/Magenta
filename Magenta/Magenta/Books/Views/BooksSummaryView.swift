//
//  BooksSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct BooksSummaryView: View {
    // @StateObject private var booksSummaryViewModel: BooksSummaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("BOOKS")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "books.vertical")
                    .foregroundStyle(.brown)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Button("Review") { }
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.almostBlack)
            .cornerRadius(10)
        }
    }
}

#Preview ("Light Mode") {
    BooksSummaryView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    BooksSummaryView()
        .preferredColorScheme(.dark)
}
