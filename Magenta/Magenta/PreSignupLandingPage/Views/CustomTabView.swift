//
//  CustomTabView.swift
//  Magenta
//
//  Created by Sarah Clark on 4/10/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 20) {
            ForEach(0..<3) { index in
                Button(action: {
                    selectedTab = index
                }, label: {
                    Circle()
                        .fill(selectedTab == index ? Color.white : Color.white.opacity(0.3))
                        .frame(width: 15, height: 15)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                })
            }
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .clipShape(Capsule())
    }
}

#Preview("Light Mode") {
    CustomTabBar(selectedTab: .constant(1))
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    CustomTabBar(selectedTab: .constant(1))
        .preferredColorScheme(.dark)
}
