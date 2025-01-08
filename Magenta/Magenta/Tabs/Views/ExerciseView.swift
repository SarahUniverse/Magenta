//
//  ExerciseView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct ExerciseView: View {
    @StateObject private var exerciseViewModel = ExerciseViewModel()

    var body: some View {
        NavigationView {
            List {
                Text("Step Count: \(exerciseViewModel.stepCount)")
            }
            .navigationTitle("Exercise")
            .toolbarBackground(.darkBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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
