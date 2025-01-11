//
//  RainbowView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/11/25.
//

import SwiftUI

struct RainbowView: View {
    var body: some View {
        ZStack {
            ForEach(0..<7) { index in
                let hue = CGFloat(index) / 7
                Path { path in
                    path.addArc(
                        center: CGPoint(x: 150, y: 150),
                        radius: CGFloat(150 - (index * 15)),
                        startAngle: .degrees(0),
                        endAngle: .degrees(180),
                        clockwise: true
                    )
                }
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 15)
            }
        }
        .padding(.all, 20)
    }
}

#Preview("Light Mode") {
    RainbowView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    RainbowView()
        .preferredColorScheme(.dark)
}
