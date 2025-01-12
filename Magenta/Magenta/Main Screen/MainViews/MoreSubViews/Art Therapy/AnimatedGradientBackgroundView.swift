//
//  CoreAnimationView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/11/25.
//

import SwiftUI
import QuartzCore

struct AnimatedGradientBackgroundView: UIViewRepresentable {
    @Binding var revealProgress: CGFloat

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        gradientLayer.colors = [
            UIColor.blue1.cgColor,
            UIColor.lightPurple.cgColor,
            UIColor.mediumPurple.cgColor,
            UIColor.purple4.cgColor,
            UIColor.darkPurple.cgColor,
            UIColor.darkBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        // Mask layer to reveal gradient
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 100)
        gradientLayer.mask = maskLayer

        containerView.layer.addSublayer(gradientLayer)

        // Store layers for animation
        context.coordinator.gradientLayer = gradientLayer
        context.coordinator.maskLayer = maskLayer

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let gradientLayer = context.coordinator.gradientLayer,
              let maskLayer = context.coordinator.maskLayer else { return }

        // Animate mask layer width to reveal gradient
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
        var gradientLayer: CAGradientLayer?
        var maskLayer: CALayer?
    }
}
