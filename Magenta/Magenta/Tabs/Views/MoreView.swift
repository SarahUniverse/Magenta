//
//  MoreView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MoreView: View {
    @StateObject private var moreViewModel = MoreViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: moreViewModel.columns, spacing: 20) {
                    ForEach(0..<moreViewModel.items.count, id: \.self) { index in
                        Button {
                            moreViewModel.handleItemTap(at: index)
                        } label: {
                            GridItemView(
                                icon: moreViewModel.items[index].icon,
                                title: moreViewModel.items[index].title
                            )
                        }
                    }
                }
                .padding()
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        moreViewModel.handleSignOut()
                    }
                    .bold()
                    .foregroundStyle(.darkPurple)
                }
            }
            .navigationBarTitle(moreViewModel.navigationTitle)
        }
    }
}

// MARK: - Previews
#Preview ("Light Mode") {
    MoreView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    MoreView()
        .preferredColorScheme(.dark)
}
