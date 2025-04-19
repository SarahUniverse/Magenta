//
//  NutritionModel.swift
//  Magenta
//
//  Created by Sarah Clark on 4/17/25.
//

import Foundation

struct NutritionModel: Identifiable, Equatable {
    let id: UUID
    let waterIntake: Double
    let totalCalories: Double
    let proteinIntake: Double
    let waterIntakeGoal: Double
    let caloriesIntakeGoal: Double
    let proteinIntakeGoal: Double
    let dateLogged: Date

    init(
        id: UUID = UUID(),
        waterIntake: Double,
        totalCalories: Double,
        proteinIntake: Double,
        waterIntakeGoal: Double,
        caloriesIntakeGoal: Double,
        proteinIntakeGoal: Double,
        dateLogged: Date
    ) {
        self.id = id
        self.waterIntake = waterIntake
        self.totalCalories = totalCalories
        self.proteinIntake = proteinIntake
        self.waterIntakeGoal = waterIntakeGoal
        self.caloriesIntakeGoal = caloriesIntakeGoal
        self.proteinIntakeGoal = proteinIntakeGoal
        self.dateLogged = dateLogged
    }

    init(from entity: NutritionEntity, goalEntity: NutritionGoalEntity?) {
        self.id = entity.id ?? UUID()
        self.waterIntake = entity.waterIntake
        self.totalCalories = entity.totalCalories
        self.proteinIntake = entity.proteinIntake
        self.dateLogged = entity.dateLogged ?? Date()
        self.waterIntakeGoal = goalEntity?.waterIntakeGoal ?? 0.0
        self.caloriesIntakeGoal = goalEntity?.caloriesIntakeGoal ?? 0.0
        self.proteinIntakeGoal = goalEntity?.proteinIntakeGoal ?? 0.0
    }

}
