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

    // State for intakes and goals
    var waterIntake: Double = 0.0
    var calorieIntake: Double = 0.0
    var proteinIntake: Double = 0.0
    var nutritionGoals: [NutritionGoalEntity] = []

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchGoals()
        requestHealthKitAuthorization()
    }

    // MARK: - CoreData Operations
    func addWaterIntake(ounces: Double) {
        waterIntake += ounces
        let nutritionEntity = NutritionEntity(context: viewContext)
        nutritionEntity.id = UUID()
        nutritionEntity.waterIntake = waterIntake
        nutritionEntity.totalCalories = calorieIntake
        nutritionEntity.proteinIntake = proteinIntake
        nutritionEntity.dateLogged = Date()
        saveContext()
        saveToHealthKit(waterIntake: ounces)
    }

    func saveGoals(waterIntakeGoal: Double, caloriesIntakeGoal: Double, proteinIntakeGoal: Double) {
        let goalEntity = NutritionGoalEntity(context: viewContext)
        goalEntity.id = UUID()
        goalEntity.waterIntakeGoal = waterIntakeGoal
        goalEntity.caloriesIntakeGoal = caloriesIntakeGoal
        goalEntity.proteinIntakeGoal = proteinIntakeGoal
        goalEntity.dateLogged = Date()
        saveContext()
        fetchGoals()
    }

    func fetchGoals() {
        let request: NSFetchRequest<NutritionGoalEntity> = NutritionGoalEntity.fetchRequest()
        do {
            nutritionGoals = try viewContext.fetch(request)
        } catch {
            print("Error fetching goals: \(error)")
        }
    }

    func fetchNutritionModel(for date: Date) -> NutritionModel {
        let nutritionRequest: NSFetchRequest<NutritionEntity> = NutritionEntity.fetchRequest()
        nutritionRequest.predicate = NSPredicate(format: "dateLogged == %@", date as NSDate)
        nutritionRequest.fetchLimit = 1

        let goalRequest: NSFetchRequest<NutritionGoalEntity> = NutritionGoalEntity.fetchRequest()
        goalRequest.predicate = NSPredicate(format: "dateLogged == %@", date as NSDate)
        goalRequest.fetchLimit = 1

        do {
            let nutritionEntities = try viewContext.fetch(nutritionRequest)
            let goalEntities = try viewContext.fetch(goalRequest)
            let nutritionEntity = nutritionEntities.first
            let goalEntity = goalEntities.first
            return NutritionModel(from: nutritionEntity ?? NutritionEntity(context: viewContext), goalEntity: goalEntity)
        } catch {
            print("Error fetching nutrition model: \(error)")
            return NutritionModel(
                waterIntake: 0,
                totalCalories: 0,
                proteinIntake: 0,
                waterIntakeGoal: 0,
                caloriesIntakeGoal: 0,
                proteinIntakeGoal: 0,
                dateLogged: date
            )
        }
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
