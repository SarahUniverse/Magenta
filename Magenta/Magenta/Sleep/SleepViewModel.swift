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
    let healthKitManager: HealthKitManager
    var sleepSamples: [HKCategorySample]? = []
    var errorMessage: String?
    var hasOptedIntoSleepTracking: Bool = false
    private let sleepOptInKey = "hasOptedInToSleepTracking"
    private let viewContext: NSManagedObjectContext

    var isAuthorizationGranted: Bool {
        healthKitManager.isSleepAuthorizationGranted
    }

    var latestSleepDuration: Double? {
        healthKitManager.latestSleepDuration
    }

    init(viewContext: NSManagedObjectContext, healthKitManager: HealthKitManager = .shared) {
        self.viewContext = viewContext
        self.healthKitManager = healthKitManager
        let userDefaultsValue = UserDefaults.standard.bool(forKey: sleepOptInKey)
        let healthKitAuth = healthKitManager.isSleepAuthorizationGranted
        self.hasOptedIntoSleepTracking = userDefaultsValue || healthKitAuth
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

    func getSleepData() {
        healthKitManager.fetchSleepData()
    }

    // MARK: Private Functions
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
