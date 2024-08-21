//
//  CustomGoogleSignInButton.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import GoogleSignIn
import SwiftUI

struct CustomGoogleSignInButton: UIViewRepresentable {

    var action: () -> Void

    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.style = .standard
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        return button
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        // Added this function stub because it's required by the UIViewRepresentable protocol.
    }

    class Coordinator: NSObject {
        var parent: CustomGoogleSignInButton

        init(_ parent: CustomGoogleSignInButton) {
            self.parent = parent
        }

        @objc func buttonTapped() {
            parent.action()
        }
    }
}

