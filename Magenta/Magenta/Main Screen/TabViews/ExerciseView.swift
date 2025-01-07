//
//  ExerciseView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct ExerciseView: View {

    @StateObject private var healthKitManager = HealthKitManager()
    @State private var stepCount: Int = 0

    var body: some View {
        NavigationView {
            List {
                Text("Step Count: \(stepCount)")
            }
            .navigationTitle("Exercise")
            .toolbarBackground(.purple2, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
            .onAppear {
                healthKitManager.fetchStepCount { _ in
                    fetchSteps()
                }
            }
        }
    }

    func fetchSteps() {
        healthKitManager.fetchStepCount { steps in
            // Update the step count on the main thread since we're modifying SwiftUI state
            DispatchQueue.main.async {
                self.stepCount = Int(steps)
            }
        }
    }

}

#Preview {
    ExerciseView()
}
