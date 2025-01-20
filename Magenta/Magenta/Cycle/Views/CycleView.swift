//
//  CycleView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct CycleView: View {
    @StateObject private var cycleViewModel = CycleViewModel()

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .pink, location: 0),
            Gradient.Stop(color: .pink.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .pink.opacity(0.3), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        NavigationStack {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Cycle")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    CycleView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    CycleView()
        .preferredColorScheme(.dark)
}
