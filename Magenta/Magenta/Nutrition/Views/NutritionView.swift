//
//  NutritionView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

struct NutritionView: View {
    @State private var nutritionViewModel: NutritionViewModel
    @State private var mealName: String = ""
    @State private var mealCalories: String = ""
    @State private var waterOunces: String = ""
    @State private var selectedMood: String = "Happy"
    @State private var showEditSheet = false
    private let moods = ["Happy", "Calm", "Sad", "Anxious"]
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _nutritionViewModel = State(wrappedValue: NutritionViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                NutritionGoalGaugeSection(
                    showEditSheet: $showEditSheet,
                    nutritionGoal: NutritionModel(
                        waterIntake: 50,
                        totalCalories: 1100,
                        dateLogged: Date(),
                        proteinIntake: 69
                    )
                )
                logCaloriesSection
                logWaterSection
                logProteinSection
            }
            .navigationTitle("Nutrition")
            .background(AppGradients.backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                toolbarContent
            }
        }
    }

    // MARK: - Private Variables
    private var logProteinSection: some View {
        Text("logProteinSection")
    }

    private var logCaloriesSection: some View {
        Text("logCaloriesSection")
    }

    private var logWaterSection: some View {
        Section(header: Text("Log Water Intake")) {
            TextField("Ounces", text: $waterOunces)
                .keyboardType(.decimalPad)
            Button("Add Water") {
                if let ounces = Double(waterOunces) {
                    nutritionViewModel.addWaterIntake(ounces: ounces)
                    waterOunces = ""
                }
            }
            .disabled(waterOunces.isEmpty)
            Text("Total Water Today: \(nutritionViewModel.waterIntake, specifier: "%.1f") oz")
        }
    }

    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Image(systemName: "plus.circle.fill")
                .foregroundStyle(.white, .indigo)
                .shadow(radius: 5, y: 3)
                .onTapGesture {
                    // Optional: Open a modal for quick logging
                }
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let context = NutritionView.createPreviewContext()
    NutritionView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let context = NutritionView.createPreviewContext()
    NutritionView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension NutritionView {
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
