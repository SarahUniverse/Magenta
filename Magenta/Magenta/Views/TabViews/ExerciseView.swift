//
//  ExerciseView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftUI

struct ExerciseView: View {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .accent
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    @StateObject private var healthKitManager = HealthKitManager()
    @State private var stepCount: Int = 0

    var body: some View {
        NavigationStack {
            List {
                Text("Step Count: \(stepCount)")
            }
            .navigationTitle("Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
            .onAppear {
                healthKitManager.fetchStepCount { steps in
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
