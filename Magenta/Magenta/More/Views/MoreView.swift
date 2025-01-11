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
        HStack() {
            Spacer()
            Button(action: {
                moreViewModel.signOut()
            }, label: {
                HStack {
                    Text("Sign Out")
                        .font(.title)
                }
                .padding(.trailing, 30)
                .foregroundStyle(signOutButtonColor())
            })
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
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
        Spacer()

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
