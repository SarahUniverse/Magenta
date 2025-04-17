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
    private let moods = ["Happy", "Calm", "Sad", "Anxious"]
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _nutritionViewModel = State(wrappedValue: NutritionViewModel(viewContext: viewContext))
    }

    // MARK: Body
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Nutritional Tips for Mental Well-Being")) {
                    ForEach(nutritionViewModel.nutritionalTips, id: \.self) { tip in
                        Text(tip)
                    }
                }

                Section(header: Text("Log a Meal")) {
                    TextField("Meal Name", text: $mealName)
                    TextField("Calories", text: $mealCalories)
                        .keyboardType(.decimalPad)
                    Button("Add Meal") {
                        if let calories = Double(mealCalories), !mealName.isEmpty {
                            nutritionViewModel.addMeal(name: mealName, calories: calories, date: Date())
                            nutritionViewModel.saveMealToHealthKit(calories: calories)
                            mealName = ""
                            mealCalories = ""
                        }
                    }
                    .disabled(mealName.isEmpty || mealCalories.isEmpty)
                }

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

                Section(header: Text("Recent Meals")) {
                    ForEach(nutritionViewModel.meals) { meal in
                        HStack {
                            Text(meal.name ?? "Unknown")
                            Spacer()
                            Text("\(meal.calories, specifier: "%.0f") kcal")
                        }
                    }
                }
            }
            .navigationTitle("Nutrition")
            .background(AppGradients.backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
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
