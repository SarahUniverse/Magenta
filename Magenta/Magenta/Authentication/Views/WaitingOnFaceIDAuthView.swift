//
//  WaitingOnFaceIDAuthView.swift
//  Magenta
//
//  Created by Sarah Clark on 2/16/25.
//

import SwiftUI

struct WaitingOnFaceIDAuthView: View {

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.lightPurple,
            Color.darkPurple,
            Color.darkBlue,
            Color.black
        ]),
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )

    // MARK: - Main View Code
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            VStack {
                Spacer()
                Spacer()
                CopyrightView()
                    .padding(.bottom)
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    WaitingOnFaceIDAuthView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    WaitingOnFaceIDAuthView()
        .preferredColorScheme(.dark)
}
