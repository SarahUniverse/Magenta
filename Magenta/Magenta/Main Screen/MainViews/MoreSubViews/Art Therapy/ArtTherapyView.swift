//
//  ArtTherapyView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct ArtTherapyView: View {
    @StateObject private var viewModel = ArtTherapyViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RainbowBackgroundView(revealProgress: $viewModel.revealProgress)
                    .frame(height: 100)

                HStack {
                    Text("Art Therapy")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                }
                .padding(.top, 20)

                Image(systemName: "paintbrush.pointed.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .orange, .yellow, .green, .blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: CGFloat(viewModel.revealProgress * UIScreen.main.bounds.width - 220) - 25)
            }
            .onAppear {
                viewModel.startPainting()
            }
            .frame(height: 100)

            List {
                Text("Art Project idea one")
                Text("Art Project idea two")
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
