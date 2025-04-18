//
//  NutritionGoalGaugeSection.swift
//  Magenta
//
//  Created by Sarah Clark on 4/17/25.
//

import CoreData
import SwiftUI

struct NutritionGoalGaugeSection: View {
    @Binding var showEditSheet: Bool
    let nutritionGoal: NutritionModel

    @AppStorage("nutritionalGoals") private var nutritionGoalsData: Data = Data()

    // Current max values of each that the user has achieved.
    @State private var currentWaterIntake: Double = 0.0
    @State private var currentCaloriesIntake: Double = 0.0
    @State private var currentProteinIntake: Double = 0.0

    // Current percentages for each.
    @State private var goalWaterIntakeProgress: Int = 0
    @State private var goalCaloriesIntakeProgress: Int = 0
    @State private var goalProteinIntakeProgress: Int = 0

    // Local state for editing
    @State private var localGoalWaterIntake: Double = 0.0
    @State private var localGoalCaloriesIntake: Double = 0.0
    @State private var localGoalProteinIntake: Double = 0.0

    var body: some View {
        VStack {
            headerView
            if localGoalWaterIntake <= 0 && localGoalCaloriesIntake <= 0 && localGoalProteinIntake <= 0 {
                ContentUnavailableView(
                    "No Goals Set",
                    systemImage: "target",
                    description: Text("Set some nutrition goals to track your progress!")
                )
                .padding()
                .background(GlassBackground())
                .padding(.bottom, 10)
                .padding(.top, -10)
            } else {
                HStack(spacing: 40) {
                    VStack(spacing: 10) {
                        Gauge(value: currentWaterIntake, in: 0...localGoalWaterIntake) {
                        } currentValueLabel: {
                            Text("\(goalWaterIntakeProgress)%")
                                .font(.headline)
                        } minimumValueLabel: {
                            Text("0")
                                .font(.caption2)
                        } maximumValueLabel: {
                            Text("\(Int(localGoalWaterIntake))")
                                .font(.caption2)
                        }
                        .gaugeStyle(.accessoryCircular)
                        .tint(AppGradients.waterIntakeGradient)
                        .scaleEffect(1.5)
                        Text("Weight(lbs)")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                            .lineLimit(1)
                    }

                    VStack(spacing: 10) {
                        Gauge(value: Double(currentCaloriesIntake), in: 0...Double(localGoalCaloriesIntake)) {
                            Text("Reps")
                        } currentValueLabel: {
                            Text("\(goalCaloriesIntakeProgress)%")
                                .font(.headline)
                        } minimumValueLabel: {
                            Text("0")
                                .font(.caption2)
                        } maximumValueLabel: {
                            Text("\(localGoalCaloriesIntake)")
                                .font(.caption2)
                        }
                        .gaugeStyle(.accessoryCircular)
                        .tint(AppGradients.calorieIntakeGradient)
                        .scaleEffect(1.5)
                        Text("Reps")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }

                    VStack(spacing: 10) {
                        Gauge(value: Double(currentProteinIntake), in: 0...Double(localGoalProteinIntake)) {
                            Text("Duration")
                        } currentValueLabel: {
                            Text("\(goalProteinIntakeProgress)%")
                                .font(.headline)
                        } minimumValueLabel: {
                            Text("0")
                                .font(.caption2)
                        } maximumValueLabel: {
                            Text("\(localGoalProteinIntake)")
                                .font(.caption2)
                        }
                        .gaugeStyle(.accessoryCircular)
                        .tint(AppGradients.proteinIntakeGradient)
                        .scaleEffect(1.5)
                        Text("Duration(min)")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                    }
                }
                .padding(.bottom, 20)
                .padding(.top, 50)
                .padding(.horizontal, 20)
                .background(GlassBackground())
                .padding(.bottom, 10)
                .padding(.top, -10)
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditNutritionGoalsSheet(showEditSheet: $showEditSheet,
                                    goalWaterIntake: $localGoalWaterIntake,
                                    goalCaloriesIntake: $localGoalCaloriesIntake,
                                    goalProteinIntake: $localGoalProteinIntake,
                                    onSave: saveGoals

            )
        }
        .onAppear {
            loadGoals()
            updateMaxValues()
        }
        .onChange(of: nutritionGoal) { loadGoals() }
        .onChange(of: nutritionGoalsData) { loadGoals() }
    }

    private var headerView: some View {
        HStack {
            Image(systemName: "fork.knife")
                .foregroundStyle(.gray)
                .font(.subheadline)
                .padding(.trailing, -5)
            Text("NUTRITION GOALS")
                .foregroundStyle(.gray)
                .font(.subheadline)
            Spacer()
            Button(action: {
                showEditSheet = true
            }, label: {
                if localGoalWaterIntake <= 0 && localGoalCaloriesIntake <= 0 && localGoalProteinIntake <= 0 {
                    Text("Add Goals")
                } else {
                    Text("Edit Goals")
                }
            })
        }
        .padding(.horizontal, 10)
        .padding(.top, 40)
    }

    // MARK: - Private Functions
    private func loadGoals() {
        if let data = try? JSONDecoder().decode([String: NutritionGoals].self, from: nutritionGoalsData),
           let goals = data[nutritionGoal.id.uuidString] {
            localGoalWaterIntake = goals.waterIntakeGoal
            localGoalCaloriesIntake = goals.caloriesIntakeGoal
            localGoalProteinIntake = goals.proteinIntakeGoal
        } else {
            localGoalWaterIntake = 0.0
            localGoalCaloriesIntake = 0.0
            localGoalProteinIntake = 0.0
        }
        updateProgressValues()
    }

    private func updateProgressValues() {
        goalWaterIntakeProgress = localGoalWaterIntake > 0 ? Int((currentWaterIntake / localGoalWaterIntake) * 100) : 0
        goalCaloriesIntakeProgress = localGoalCaloriesIntake > 0 ? Int((Double(currentCaloriesIntake) / Double(localGoalCaloriesIntake)) * 100) : 0
        goalProteinIntakeProgress = localGoalProteinIntake > 0 ? Int((Double(currentProteinIntake) / Double(localGoalProteinIntake)) * 100) : 0
    }

    private func saveGoals() {
        var goalsDict: [String: NutritionGoals]
        if let existingData = try? JSONDecoder().decode([String: NutritionGoals].self, from: nutritionGoalsData) {
            goalsDict = existingData
        } else {
            goalsDict = [:]
        }

        goalsDict[nutritionGoal.id.uuidString] = NutritionGoals(
            waterIntakeGoal: localGoalWaterIntake,
            caloriesIntakeGoal: localGoalCaloriesIntake,
            proteinIntakeGoal: localGoalProteinIntake
        )
        if let data = try? JSONEncoder().encode(goalsDict) {
            nutritionGoalsData = data
        }
    }

    private func updateMaxValues() {
        currentWaterIntake = nutritionGoal.waterIntake
        currentCaloriesIntake = nutritionGoal.totalCalories
        currentProteinIntake = nutritionGoal.proteinIntake
        updateProgressValues()
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    @Previewable @State var showEditSheet: Bool = true
    NutritionGoalGaugeSection(showEditSheet: $showEditSheet, nutritionGoal: NutritionModel(waterIntake: 50, totalCalories: 1100.0, dateLogged: Date(), proteinIntake: 69))
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    @Previewable @State var showEditSheet: Bool = true
    NutritionGoalGaugeSection(showEditSheet: $showEditSheet, nutritionGoal: NutritionModel(waterIntake: 50, totalCalories: 1100.0, dateLogged: Date(), proteinIntake: 69))
        .preferredColorScheme(.dark)
}
