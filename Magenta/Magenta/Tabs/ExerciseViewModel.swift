//
//  ExerciseViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/7/25.
//

import Combine
import SwiftUI

final class ExerciseViewModel: ObservableObject {
    @Published var stepCount: Int = 0
    private var healthKitManager = HealthKitManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchSteps()
    }

    func fetchSteps() {
        healthKitManager.fetchStepCount { [weak self] steps in
            DispatchQueue.main.async {
                self?.stepCount = Int(steps)
            }
        }
    }

}
