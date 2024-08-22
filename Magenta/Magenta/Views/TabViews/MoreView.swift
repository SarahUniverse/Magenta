//
//  MoreView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MoreView: View {

    let items = [
        ("fork.knife", "Nutrition"),
        ("circle.dotted", "Cycle"),
        ("moon.zzz", "Sleep"),
        ("gearshape", "Settings"),
        ("magnifyingglass", "Find a Therapist"),
        ("pencil.and.scribble", "Journal"),
        ("music.note", "Mental Health Playlists"),
        ("book", "Self Help Books"),
        ("quote.bubble", "Helpful Quotes"),
        ("paintpalette", "Art Therapy")
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            Divider()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Button(action: {
                            print("\(items[index].1) button tapped")
                        }) {
                            VStack {
                                Image(systemName: items[index].0)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                Text(items[index].1)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("More")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {

                    }
                }
            }
        }

    }

}

#Preview {
    MoreView()
}
