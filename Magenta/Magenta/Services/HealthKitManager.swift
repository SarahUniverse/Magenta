//
//  HealthKitManager.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import HealthKit
import SwiftUI

@Observable class HealthKitManager {
    let healthStore = HKHealthStore()
    var isAuthorizationGranted = false
    var latestSleepDuration: Double? // In hours
    var errorMessage: String?

    // MARK: Sleep related functionality
    func requestSleepTrackingAuthorization() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let typesToRead = Set([sleepType])

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthorizationGranted = true
                    print("HealthKit authorization granted")
                    self?.fetchSleepData()
                } else {
                    self?.isAuthorizationGranted = false
                    self?.errorMessage = "HealthKit authorization denied: \(String(describing: error))"
                    print(self?.errorMessage ?? "Unknown error")
                }
            }
        }
    }

    func fetchSleepData() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKSampleQuery(sampleType: sleepType,
                                  predicate: predicate,
                                  limit: 1, // Fetch only the latest sleep session
                                  sortDescriptors: [sortDescriptor]) { [weak self] (query, samples, error) in
            DispatchQueue.main.async {
                guard let samples = samples as? [HKCategorySample], let sample = samples.first, error == nil else {
                    self?.errorMessage = "Error fetching sleep data: \(String(describing: error))"
                    print(self?.errorMessage ?? "Unknown error")
                    return
                }

                let duration = sample.endDate.timeIntervalSince(sample.startDate)
                self?.latestSleepDuration = duration / 3600.0 // Convert seconds to hours
                print("Latest sleep from \(sample.startDate) to \(sample.endDate), Duration: \(duration) seconds")
            }
        }

        healthStore.execute(query)
    }

    // MARK: Exercise related functionality (placeholder for future use)
}
