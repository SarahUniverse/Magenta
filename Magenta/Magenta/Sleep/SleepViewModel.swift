//
//  SleepViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData
import HealthKit
import SwiftUI

@Observable final class SleepViewModel {
    private let healthKitManager: HealthKitManager

    var isAuthorizationGranted: Bool {
        healthKitManager.isSleepAuthorizationGranted
    }

    var latestSleepDuration: Double? {
        healthKitManager.latestSleepDuration
    }

    var errorMessage: String? {
        healthKitManager.errorMessage
    }

    init(healthKitManager: HealthKitManager = HealthKitManager()) {
        self.healthKitManager = healthKitManager

        guard HKHealthStore.isHealthDataAvailable() else {
            healthKitManager.errorMessage = "HealthKit is not available on this device"
            return
        }
    }

    func requestSleepTrackingAuthorization() {
        healthKitManager.requestSleepTrackingAuthorization()
    }

    func fetchSleepData() {
        healthKitManager.fetchSleepData()
    }

}
