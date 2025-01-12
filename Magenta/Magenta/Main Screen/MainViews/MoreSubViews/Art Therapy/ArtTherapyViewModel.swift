//
//  ArtTherapyViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/11/25.
//

import SwiftUI

final class ArtTherapyViewModel: ObservableObject {
    @Published var revealProgress: CGFloat = 0.0
    private var animationTimer: Timer?

    func startPainting() {
        // Reset progress
        revealProgress = 0.0

        // Animate gradient reveal
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            // Gradually increase reveal progress
            self.revealProgress += 0.01

            // Stop animation when fully revealed
            if self.revealProgress >= 1.0 {
                timer.invalidate()
            }
        }
    }
}
