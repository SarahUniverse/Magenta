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
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 2, y: 2)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.3))
                        )
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
                    .opacity(viewModel.revealProgress < 1.0 ? 1.0 : 0.0)
                    .animation(.easeInOut, value: viewModel.revealProgress)
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
