//
//  HealthKitManager.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import HealthKit
import SwiftUI

@Observable class HealthKitManager {
    static let shared = HealthKitManager()
    var sleepSamples: [HKCategorySample]?
    let healthStore = HKHealthStore()
    var isSleepAuthorizationGranted = false
    var latestSleepDuration: Double?
    var errorMessage: String?

    init() {
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
                    self?.fetchSleepData()
                } else {
                    self?.isSleepAuthorizationGranted = false
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
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor]) { [weak self] (query, samples, error) in
            DispatchQueue.main.async {
                guard let samples = samples as? [HKCategorySample], error == nil else {
                    self?.errorMessage = "Error fetching sleep data: \(String(describing: error))"
                    print(self?.errorMessage ?? "Unknown error")
                    return
                }

                for sample in samples {
                    let duration = sample.endDate.timeIntervalSince(sample.startDate) / 3600.0
                    let sleepState: String
                    switch HKCategoryValueSleepAnalysis(rawValue: sample.value) {
                    case .inBed:
                        sleepState = "In Bed"
                    case .asleep:
                        sleepState = "Asleep (Unspecified)"
                    case .awake:
                        sleepState = "Awake"
                    case .asleepCore:
                        sleepState = "Core Sleep"
                    case .asleepDeep:
                        sleepState = "Deep Sleep"
                    case .asleepREM:
                        sleepState = "REM Sleep"
                    default:
                        sleepState = "Unknown"
                    }
                    print("Sleep State: \(sleepState), Start: \(sample.startDate), End: \(sample.endDate), Duration: \(duration) hours")
                }
                // Update latestSleepDuration with total sleep time if needed
                if let latest = samples.first {
                    self?.latestSleepDuration = latest.endDate.timeIntervalSince(latest.startDate) / 3600.0
                }
            }
        }
        healthStore.execute(query)
    }

    // MARK: - Private Functions
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
            fetchSleepData()
        }
    }

    // MARK: Exercise related functionality (placeholder for future use)
}
