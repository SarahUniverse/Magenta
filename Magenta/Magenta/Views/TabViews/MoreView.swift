//
//  MoreView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MoreView: View {
    let items = [
        ("circle.dotted", "Cycle"),
        ("moon.zzz", "Sleep"),
        ("gearshape", "Settings"),
        ("magnifyingglass", "Find a Therapist")
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

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
        }

    }

}

#Preview {
    MoreView()
}
