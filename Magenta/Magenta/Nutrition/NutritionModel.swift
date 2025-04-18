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
    let dateLogged: Date
    let proteinIntake: Double

    init(id: UUID = UUID(), waterIntake: Double, totalCalories: Double, dateLogged: Date, proteinIntake: Double) {
        self.id = id
        self.waterIntake = waterIntake
        self.totalCalories = totalCalories
        self.dateLogged = dateLogged
        self.proteinIntake = proteinIntake
    }

    init(from entity: NutritionEntity) {
        self.id = entity.id ?? UUID()
        self.waterIntake = entity.waterIntake
        self.totalCalories = entity.totalCalories
        self.dateLogged = entity.dateLogged ?? Date()
        self.proteinIntake = entity.proteinIntake
    }

}
