//
//  NutritionViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData
import HealthKit
import SwiftUI

@Observable final class NutritionViewModel {
    private let viewContext: NSManagedObjectContext
    private let healthStore = HKHealthStore()

    // State for meals, water intake, mood tracking, and tips
    var nutritionGoals: [NutritionGoals] = []
    var waterIntake: Double = 0.0 // In ounces
    var calorieIntake: Double = 0.0 // In kCal
    var proteinIntake: Double = 0.0

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        requestHealthKitAuthorization()
    }

    // MARK: - CoreData Operations
    func addWaterIntake(ounces: Double) {
        waterIntake += ounces
        saveToHealthKit(waterIntake: ounces)
    }

    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    // MARK: - HealthKit Integration
    func requestHealthKitAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let typesToWrite: Set = [
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        ]

        healthStore.requestAuthorization(toShare: typesToWrite, read: nil) { success, error in
            if let error = error {
                print("HealthKit authorization error: \(error)")
            }
        }
    }

    func saveToHealthKit(waterIntake: Double) {
        guard let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else { return }
        let quantity = HKQuantity(unit: .fluidOunceUS(), doubleValue: waterIntake)
        let sample = HKQuantitySample(type: waterType, quantity: quantity, start: Date(), end: Date())

        healthStore.save(sample) { success, error in
            if let error = error {
                print("Error saving water intake to HealthKit: \(error)")
            }
        }
    }

    func saveMealToHealthKit(calories: Double) {
        guard let calorieType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else { return }
        let quantity = HKQuantity(unit: .kilocalorie(), doubleValue: calories)
        let sample = HKQuantitySample(type: calorieType, quantity: quantity, start: Date(), end: Date())

        healthStore.save(sample) { success, error in
            if let error = error {
                print("Error saving meal to HealthKit: \(error)")
            }
        }
    }

}
