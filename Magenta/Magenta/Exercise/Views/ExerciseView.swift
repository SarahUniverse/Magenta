//
//  ExerciseView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct ExerciseView: View {
    @StateObject private var exerciseViewModel = ExerciseViewModel()

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .yellow.opacity(0.8), location: 0),
            Gradient.Stop(color: .orange.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .red.opacity(0.6), location: 0.2),
            Gradient.Stop(color: .red.opacity(0.4), location: 0.3),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        NavigationStack {
            List {
                Text("Step Count: \(exerciseViewModel.stepCount)")
            }
            .navigationTitle("Exercise")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
            .onAppear {
                exerciseViewModel.fetchSteps()
            }
        }
    }

}

// MARK: - Previews
#Preview ("Light Mode") {
    ExerciseView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    ExerciseView()
        .preferredColorScheme(.dark)
}
