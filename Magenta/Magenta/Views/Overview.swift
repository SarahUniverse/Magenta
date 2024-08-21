//
//  Overview.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import SwiftUI

struct Overview: View {
    var body: some View {

        if #available(iOS 18.0, *) {
            TabView {
                Tab("Mood", systemImage: "face.smiling.inverse") { EmptyView() }
                Tab("Meditate", systemImage: "figure.mind.and.body") { EmptyView() }
                Tab("Exercise", systemImage: "figure.run") { EmptyView() }
                Tab("Nutrition", systemImage: "fork.knife") { EmptyView() }
                Tab("Cycle", systemImage: "circle.dotted") { EmptyView() }
            }
            .navigationBarBackButtonHidden(true)
        } else {
            // TODO: Remove when iOS 17 is no longer supported.
            TabView {
                tabContent(for: "Mood", systemImage: "house.fill")
                tabContent(for: "Meditate", systemImage: "figure.mind.and.body")
                tabContent(for: "Exercise", systemImage: "figure.run")
                tabContent(for: "Nutrition", systemImage: "fork.knife")
                tabContent(for: "Cycle", systemImage: "circle.dotted")
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private func tabContent(for text: String, systemImage: String) -> some View {
        Text(text)
    }

}

#Preview {
    Overview()
}
