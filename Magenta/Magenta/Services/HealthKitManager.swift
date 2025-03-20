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
    var isSleepAuthorizationGranted = false
    var latestSleepDuration: Double? // In hours
    var errorMessage: String?

    init() {
        // Check initial authorization status
        updateAuthorizationStatus()
    }

    // MARK: Sleep related functionality
    func requestSleepTrackingAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = "HealthKit is not available on this device."
            print("HealthKit not available")
            return
        }

        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let typesToRead = Set([sleepType])

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.isSleepAuthorizationGranted = true
                    print("HealthKit authorization granted")
                    //self?.fetchSleepData()
                } else {
                    self?.isSleepAuthorizationGranted = false
                    self?.errorMessage = "HealthKit authorization denied: \(String(describing: error))"
                    print(self?.errorMessage ?? "Unknown error")
                }
            }
        }
    }

    /*func fetchSleepData() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKSampleQuery(sampleType: sleepType,
                                  predicate: predicate,
                                  limit: 1, // Fetch only the latest sleep session
                                  sortDescriptors: [sortDescriptors]) { [weak self] (query, samples, error) in
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
    }*/

    private func updateAuthorizationStatus() {
        guard HKHealthStore.isHealthDataAvailable() else {
            isSleepAuthorizationGranted = false
            return
        }

        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let status = healthStore.authorizationStatus(for: sleepType)
        isSleepAuthorizationGranted = status == .sharingAuthorized
        print("Initial HealthKit sleep authorization status: \(isSleepAuthorizationGranted)")
        if isSleepAuthorizationGranted {
            //fetchSleepData()
            print("Sleep Authorization is granted.")
        }
    }

    // MARK: Exercise related functionality (placeholder for future use)
}
