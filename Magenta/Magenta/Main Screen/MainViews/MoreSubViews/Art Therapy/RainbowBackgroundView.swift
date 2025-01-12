//
//  CoreAnimationView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/11/25.
//

import SwiftUI
import QuartzCore

struct RainbowBackgroundView: UIViewRepresentable {
    @Binding var revealProgress: CGFloat

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear

        // Create rainbow gradient layer
        let rainbowLayer = CAGradientLayer()
        rainbowLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        rainbowLayer.colors = [
            UIColor.blue1.cgColor,
            UIColor.lightPurple.cgColor,
            UIColor.mediumPurple.cgColor,
            UIColor.purple4.cgColor,
            UIColor.darkPurple.cgColor,
            UIColor.darkBlue.cgColor
        ]
        rainbowLayer.startPoint = CGPoint(x: 0, y: 0.5)
        rainbowLayer.endPoint = CGPoint(x: 1, y: 0.5)

        // Mask layer to reveal gradient
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 100)
        rainbowLayer.mask = maskLayer

        containerView.layer.addSublayer(rainbowLayer)

        // Store layers for animation
        context.coordinator.rainbowLayer = rainbowLayer
        context.coordinator.maskLayer = maskLayer

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let rainbowLayer = context.coordinator.rainbowLayer,
              let maskLayer = context.coordinator.maskLayer else { return }

        // Animate mask layer width to reveal rainbow
        maskLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width * revealProgress,
            height: 100
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var rainbowLayer: CAGradientLayer?
        var maskLayer: CALayer?
    }
}
