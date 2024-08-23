//
//  HealthKitManager.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import HealthKit

class HealthKitManager: ObservableObject {
    let healthStore: HKHealthStore?
    @Published var stepCount: Double = 0

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            healthStore = nil
            print("HealthKit is not available on this device.")
        }
    }

    func setupHealthKit() {
        guard let healthStore = self.healthStore else { return }
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                print("Error requesting authorization from HealthKit: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func fetchStepCount(completion: @escaping (Double) -> Void) {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("Step count type is no longer available in HealthKit")
            return
        }

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepCountType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to fetch step count: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let steps = sum.doubleValue(for: HKUnit.count())
            completion(steps)
        }

        healthStore?.execute(query)
    }
}
