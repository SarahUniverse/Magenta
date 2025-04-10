//
//  TabbedContentView.swift
//  Magenta
//
//  Created by Sarah Clark on 4/10/25.
//

import SwiftUI

struct TabbedContentView: View {
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            switch selectedTab {
                case 0:
                    FeatureView(
                        icon: "pencil.circle.fill",
                        title: "Create",
                        description: "Draw, paint, and design with intuitive tools."
                    )
                case 1:
                    FeatureView(
                        icon: "photo.circle.fill",
                        title: "Edit",
                        description: "Enhance your photos with powerful editing features."
                    )
                case 2:
                    FeatureView(
                        icon: "square.and.arrow.up.circle.fill",
                        title: "Share",
                        description: "Showcase your work to a global community."
                    )
                default:
                    EmptyView()
            }
        }
        .frame(height: 150)
        .padding(.horizontal)
    }
}

#Preview("Light Mode"){
    TabbedContentView(selectedTab: .constant(0))
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    TabbedContentView(selectedTab: .constant(0))
        .preferredColorScheme(.dark)
}
