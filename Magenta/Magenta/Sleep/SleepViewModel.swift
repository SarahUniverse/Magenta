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

        // Integrate a week's worth of sample sleep data (March 13–19, 2025)
        let calendar = Calendar.current
        let now = Date() // March 20, 2025
        var samples: [HKCategorySample] = []

        for dayOffset in -7...(-1) { // Last 7 days
            let dayStart = calendar.date(byAdding: .day, value: dayOffset, to: now)!
            let startOfDay = calendar.startOfDay(for: dayStart)

            // March 13: Short sleep with interruptions
            if dayOffset == -7 {
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: calendar.date(byAdding: .hour, value: 23, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 24, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepCore.rawValue, start: calendar.date(byAdding: .hour, value: 24, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 26, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.awake.rawValue, start: calendar.date(byAdding: .hour, value: 26, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 27, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepDeep.rawValue, start: calendar.date(byAdding: .hour, value: 27, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 28, to: startOfDay)!, device: nil, metadata: nil))
            }
            // March 14: Normal sleep
            else if dayOffset == -6 {
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: calendar.date(byAdding: .hour, value: 22, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 23, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepCore.rawValue, start: calendar.date(byAdding: .hour, value: 23, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 27, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepREM.rawValue, start: calendar.date(byAdding: .hour, value: 27, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 29, to: startOfDay)!, device: nil, metadata: nil))
            }
            // March 15: Long sleep
            else if dayOffset == -5 {
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: calendar.date(byAdding: .hour, value: 21, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 22, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepCore.rawValue, start: calendar.date(byAdding: .hour, value: 22, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 26, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepDeep.rawValue, start: calendar.date(byAdding: .hour, value: 26, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 28, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepREM.rawValue, start: calendar.date(byAdding: .hour, value: 28, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 30, to: startOfDay)!, device: nil, metadata: nil))
            }
            // March 16: Restless night
            else if dayOffset == -4 {
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: calendar.date(byAdding: .hour, value: 23, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 24, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepCore.rawValue, start: calendar.date(byAdding: .hour, value: 24, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 25, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.awake.rawValue, start: calendar.date(byAdding: .hour, value: 25, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 26, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepCore.rawValue, start: calendar.date(byAdding: .hour, value: 26, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 28, to: startOfDay)!, device: nil, metadata: nil))
            }
            // March 17: Early sleep
            else if dayOffset == -3 {
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: calendar.date(byAdding: .hour, value: 20, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 21, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepCore.rawValue, start: calendar.date(byAdding: .hour, value: 21, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 25, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepREM.rawValue, start: calendar.date(byAdding: .hour, value: 25, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 27, to: startOfDay)!, device: nil, metadata: nil))
            }
            // March 18: Late sleep
            else if dayOffset == -2 {
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: calendar.date(byAdding: .hour, value: 24, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 25, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepCore.rawValue, start: calendar.date(byAdding: .hour, value: 25, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 29, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepDeep.rawValue, start: calendar.date(byAdding: .hour, value: 29, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 30, to: startOfDay)!, device: nil, metadata: nil))
            }
            // March 19: Typical night
            else if dayOffset == -1 {
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: calendar.date(byAdding: .hour, value: 22, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 23, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepCore.rawValue, start: calendar.date(byAdding: .hour, value: 23, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 27, to: startOfDay)!, device: nil, metadata: nil))
                samples.append(HKCategorySample(type: HKCategoryType(.sleepAnalysis), value: HKCategoryValueSleepAnalysis.asleepREM.rawValue, start: calendar.date(byAdding: .hour, value: 27, to: startOfDay)!, end: calendar.date(byAdding: .hour, value: 29, to: startOfDay)!, device: nil, metadata: nil))
            }
        }
        self.sleepSamples = samples
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
        if let fetchedSamples = healthKitManager.sleepSamples {
            self.sleepSamples = fetchedSamples
        }
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
