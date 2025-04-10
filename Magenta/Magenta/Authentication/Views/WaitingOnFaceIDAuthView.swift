//
//  WaitingOnFaceIDAuthView.swift
//  Magenta
//
//  Created by Sarah Clark on 2/16/25.
//

import SwiftUI

struct WaitingOnFaceIDAuthView: View {

    // MARK: - Body
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
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
