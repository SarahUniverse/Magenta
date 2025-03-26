//
//  NutritionView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct NutritionView: View {
    @State private var nutritionViewModel = NutritionViewModel()

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .green, location: 0),
            Gradient.Stop(color: .green.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .green.opacity(0.3), location: 0.2),
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
            .navigationTitle("Nutrition Matters")
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
    NutritionView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NutritionView()
        .preferredColorScheme(.dark)
}
