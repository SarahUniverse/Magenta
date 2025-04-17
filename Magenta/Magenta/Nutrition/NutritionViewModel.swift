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
    var meals: [NutritionEntity] = []
    var waterIntake: Double = 0.0 // In ounces
    var nutritionalTips: [String] = [
        "Omega-3 fatty acids (found in salmon, walnuts) support brain health.",
        "Complex carbs like whole grains stabilize mood.",
        "Stay hydrated to improve focus and reduce fatigue.",
        "Dark chocolate in moderation can boost serotonin levels."
    ]

    // Personalized meal suggestions based on mood and preferences
    var mealSuggestions: [String] = []

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchMeals()
        requestHealthKitAuthorization()
    }

    // MARK: - CoreData Operations
    func fetchMeals() {
        let request: NSFetchRequest<NutritionEntity> = NutritionEntity.fetchRequest()
        do {
            meals = try viewContext.fetch(request)
        } catch {
            print("Error fetching meals: \(error)")
        }
    }

    func addMeal(name: String, calories: Double, date: Date) {
        let newMeal = NutritionEntity(context: viewContext)
        newMeal.id = UUID()
        newMeal.foodName = name
        newMeal.calories = calories
        newMeal.dateLogged = date
        saveContext()
        fetchMeals()
    }

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
