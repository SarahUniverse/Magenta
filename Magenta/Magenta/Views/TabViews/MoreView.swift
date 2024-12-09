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

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.darkPurple,
            Color.darkBlue
        ]),
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )

    var body: some View {
        NavigationStack {
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
                                    .foregroundStyle(.mediumBlue)
                                Text(items[index].1)
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                    }
                    .bold()
                    .foregroundStyle(.mediumBlue)
                }
            }
            .navigationBarTitle("More")
            .background(backgroundGradient)
        }
    }
}

#Preview {
    MoreView()
}
