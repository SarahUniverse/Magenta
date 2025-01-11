//
//  MoreView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct MoreView: View {
    @StateObject var moreViewModel: MoreViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
            ScrollView {
                Button(action: {
                    moreViewModel.signOut()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Sign Out")
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                    .foregroundStyle(signOutButtonColor())
                    .cornerRadius(10)
                }
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

        .fullScreenCover(isPresented: $moreViewModel.shouldShowLoginView) {
            LoginView(viewContext: moreViewModel.viewContext)
        }
    }

    // MARK: - Private functions
    private func signOutButtonColor() -> Color {
        colorScheme == .dark ? .white : .black
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    MoreView(moreViewModel: MoreViewModel.createPreviewViewModel())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    MoreView(moreViewModel: MoreViewModel.createPreviewViewModel())
        .preferredColorScheme(.dark)
}
