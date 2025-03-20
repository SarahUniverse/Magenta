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
    var errorMessage: String?
    var hasOptedIntoSleepTracking: Bool = false
    private let sleepOptInKey = "hasOptedInToSleepTracking"

    var isAuthorizationGranted: Bool {
        healthKitManager.isSleepAuthorizationGranted
    }

    var latestSleepDuration: Double? {
        healthKitManager.latestSleepDuration
    }

    init(healthKitManager: HealthKitManager = .shared) {
        self.healthKitManager = healthKitManager
        let userDefaultsValue = UserDefaults.standard.bool(forKey: sleepOptInKey)
        let healthKitAuth = healthKitManager.isSleepAuthorizationGranted
        print("Initializing SleepViewModel - UserDefaults value for \(sleepOptInKey): \(userDefaultsValue), HealthKit auth: \(healthKitAuth)")
        self.hasOptedIntoSleepTracking = userDefaultsValue || healthKitAuth
        checkSleepAuthorization()
    }

    func requestSleepTrackingAuthorization() {
        healthKitManager.requestSleepTrackingAuthorization()
        if healthKitManager.isSleepAuthorizationGranted {
            hasOptedIntoSleepTracking = true
            UserDefaults.standard.set(true, forKey: sleepOptInKey)
            print("After requesting authorization, UserDefaults value for \(sleepOptInKey): true")
        } else {
            errorMessage = healthKitManager.errorMessage
        }
    }

    func completeSleepOptIn() {
        print("Setting UserDefaults value for \(sleepOptInKey) to true")
        UserDefaults.standard.set(true, forKey: sleepOptInKey)
        let savedValue = UserDefaults.standard.bool(forKey: sleepOptInKey)
        print("After setting, UserDefaults value for \(sleepOptInKey): \(savedValue)")
        requestSleepTrackingAuthorization()
        hasOptedIntoSleepTracking = true
    }

    private func checkSleepAuthorization() {
        if healthKitManager.isSleepAuthorizationGranted {
            print("HealthKit authorization granted, setting UserDefaults")
            UserDefaults.standard.set(true, forKey: sleepOptInKey)
            let savedValue = UserDefaults.standard.bool(forKey: sleepOptInKey)
            print("After checkSleepAuthorization, UserDefaults value for \(sleepOptInKey): \(savedValue)")
            hasOptedIntoSleepTracking = true
        }
    }

}
