//
//  MoreView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MoreView: View {
    @StateObject private var viewModel = MoreViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: viewModel.columns, spacing: 20) {
                    ForEach(0..<viewModel.items.count, id: \.self) { index in
                        Button {
                            viewModel.handleItemTap(at: index)
                        } label: {
                            GridItemView(
                                icon: viewModel.items[index].icon,
                                title: viewModel.items[index].title
                            )
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
                        viewModel.handleSignOut()
                    }
                    .bold()
                    .foregroundStyle(.mediumBlue)
                }
            }
            .navigationBarTitle(viewModel.navigationTitle)
            .background(viewModel.backgroundGradient)
        }
    }
}

#Preview ("Light Mode") {
    MoreView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    MoreView()
        .preferredColorScheme(.dark)
}
