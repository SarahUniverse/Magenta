//
//  ArtTherapyView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct ArtTherapyView: View {
    @ObservedObject var viewModel = ArtTherapyViewModel()
    @State private var isBackgroundRevealed = false
    @State private var isPainting = false

    // Gradient matching the paintbrush
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.pink, .purple, .blue]),
            startPoint: .bottom,
            endPoint: .top
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Painting Reveal Background
                backgroundGradient
                    .mask(
                        Rectangle()
                            .modifier(PaintRevealModifier(isRevealed: isBackgroundRevealed))
                    )
                    .onAppear {
                        // Start revealing background
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                isBackgroundRevealed = true
                            }
                        }

                        // Start painting after background is revealed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isPainting = true
                            viewModel.startPaintingOnce()
                        }
                    }
                HStack {
                    Text("Art Therapy")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()

                // Painting Animation
                if isPainting {
                    Canvas { context, size in
                        for (index, point) in viewModel.points.enumerated() {
                            let hue = Double(index) / Double(viewModel.points.count)
                            let color = Color(hue: hue, saturation: 1, brightness: 1)

                            context.stroke(
                                Path { colorPath in
                                    colorPath.move(to: point)
                                    colorPath.addLine(to: point)
                                },
                                with: .color(color),
                                lineWidth: 10
                            )
                        }
                    }

                    Image(systemName: "paintbrush.pointed.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.black)
                        .position(viewModel.points.last ?? .zero)
                }
            }
            .frame(height: 100)

            // List Content
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
