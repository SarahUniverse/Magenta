//
//  NutritionModel.swift
//  Magenta
//
//  Created by Sarah Clark on 4/17/25.
//

import Foundation

struct NutritionModel: Identifiable {
    let id: UUID
    let waterIntake: Double
    let calories: Double
    let dateLogged: Date
    let foodName: String
    let proteinIntake: Double

    init(id: UUID = UUID(), waterIntake: Double, calories: Double, dateLogged: Date, foodName: String, proteinIntake: Double) {
        self.id = id
        self.waterIntake = waterIntake
        self.calories = calories
        self.dateLogged = dateLogged
        self.foodName = foodName
        self.proteinIntake = proteinIntake
    }

    init(from entity: NutritionEntity) {
        self.id = entity.id ?? UUID()
        self.waterIntake = entity.waterIntake
        self.calories = entity.calories
        self.dateLogged = entity.dateLogged ?? Date()
        self.foodName = entity.foodName ?? ""
        self.proteinIntake = entity.proteinIntake
    }

}
