//
//  NutritionGoalGaugeSection.swift
//  Magenta
//
//  Created by Sarah Clark on 4/17/25.
//

import CoreData
import SwiftUI

struct NutritionGoalGaugeSection: View {
    @State private var nutritionViewModel: NutritionViewModel
    @Binding var showEditSheet: Bool
    let nutritionGoal: NutritionModel
    private let viewContext: NSManagedObjectContext

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

    init(viewContext: NSManagedObjectContext, showEditSheet: Binding<Bool>, nutritionGoal: NutritionModel) {
        self.viewContext = viewContext
        _nutritionViewModel = State(wrappedValue: NutritionViewModel(viewContext: viewContext))
        self._showEditSheet = showEditSheet
        self.nutritionGoal = nutritionGoal
    }

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
                        Text("Water(oz)")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                            .lineLimit(1)
                    }

                    VStack(spacing: 10) {
                        Gauge(value: Double(currentCaloriesIntake), in: 0...Double(localGoalCaloriesIntake)) {
                            Text("Calories")
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
                        Text("Kcal")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }

                    VStack(spacing: 10) {
                        Gauge(value: Double(currentProteinIntake), in: 0...Double(localGoalProteinIntake)) {
                            Text("Protein")
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
                        Text("Protein(g)")
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
            EditNutritionGoalsSheet(
                showEditSheet: $showEditSheet,
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
        localGoalWaterIntake = nutritionGoal.waterIntakeGoal
        localGoalCaloriesIntake = nutritionGoal.caloriesIntakeGoal
        localGoalProteinIntake = nutritionGoal.proteinIntakeGoal
        updateProgressValues()
    }

    private func updateProgressValues() {
        goalWaterIntakeProgress = localGoalWaterIntake > 0 ? Int((currentWaterIntake / localGoalWaterIntake) * 100) : 0
        goalCaloriesIntakeProgress = localGoalCaloriesIntake > 0 ? Int((Double(currentCaloriesIntake) / Double(localGoalCaloriesIntake)) * 100) : 0
        goalProteinIntakeProgress = localGoalProteinIntake > 0 ? Int((Double(currentProteinIntake) / Double(localGoalProteinIntake)) * 100) : 0
    }

    private func saveGoals() {
        nutritionViewModel.saveGoals(
            waterIntakeGoal: localGoalWaterIntake,
            caloriesIntakeGoal: localGoalCaloriesIntake,
            proteinIntakeGoal: localGoalProteinIntake
        )
        // Reload goals to update the view
        loadGoals()
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
    struct PreviewWrapper: View {
        @State var showEditSheet: Bool = false

        var body: some View {
            let context = NutritionGoalGaugeSection.createPreviewContext()
            NutritionGoalGaugeSection(
                viewContext: context,
                showEditSheet: $showEditSheet,
                nutritionGoal: NutritionModel(
                    id: UUID(),
                    waterIntake: 50.0,
                    totalCalories: 1100.0,
                    proteinIntake: 69.0,
                    waterIntakeGoal: 64.0,
                    caloriesIntakeGoal: 2000.0,
                    proteinIntakeGoal: 150.0,
                    dateLogged: Date()
                )
            )
            .environment(\.managedObjectContext, context)
            .preferredColorScheme(.light)
        }
    }

    return PreviewWrapper()
}

#Preview("Dark Mode") {
    struct PreviewWrapper: View {
        @State var showEditSheet: Bool = false

        var body: some View {
            let context = NutritionGoalGaugeSection.createPreviewContext()
            NutritionGoalGaugeSection(
                viewContext: context,
                showEditSheet: $showEditSheet,
                nutritionGoal: NutritionModel(
                    id: UUID(),
                    waterIntake: 50.0,
                    totalCalories: 1100.0,
                    proteinIntake: 69.0,
                    waterIntakeGoal: 64.0,
                    caloriesIntakeGoal: 2000.0,
                    proteinIntakeGoal: 150.0,
                    dateLogged: Date()
                )
            )
            .environment(\.managedObjectContext, context)
            .preferredColorScheme(.dark)
        }
    }

    return PreviewWrapper()
}

extension NutritionGoalGaugeSection {
    static func createPreviewContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack for preview: \(error)")
            }
        }
        return container.viewContext
    }
}
