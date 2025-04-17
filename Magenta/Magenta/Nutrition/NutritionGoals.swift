//
//  NutritionGoals.swift
//  Magenta
//
//  Created by Sarah Clark on 4/17/25.
//

struct NutritionGoals: Codable {
    var waterIntakeGoal: Double
    var caloriesIntakeGoal: Double
    var proteinIntakeGoal: Double

    static let defaultNutritionGoals = NutritionGoals(waterIntakeGoal: 0.0, caloriesIntakeGoal: 0.0, proteinIntakeGoal: 0.0)
}
