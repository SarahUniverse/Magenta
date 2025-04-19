//
//  EditNutritionGoalsSheet.swift
//  Magenta
//
//  Created by Sarah Clark on 4/18/25.
//

import SwiftUI

struct EditNutritionGoalsSheet: View {
    @Binding var showEditSheet: Bool
    @Binding var goalWaterIntake: Double
    @Binding var goalCaloriesIntake: Double
    @Binding var goalProteinIntake: Double
    let onSave: () -> Void

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Edit Goals")) {
                    HStack {
                        Text("Water Goal (oz)")
                        Spacer()
                        TextField("Water goal", value: $goalWaterIntake, formatter: decimalFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Text("Calorie Intake (Kcal)")
                        Spacer()
                        TextField("Calories", value: $goalCaloriesIntake, formatter: integerFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Protein Intake (g)")
                        Spacer()
                        TextField("Protein", value: $goalProteinIntake, formatter: integerFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .navigationTitle("Edit Nutrition goals")
            .navigationBarItems(
                leading: Button("Cancel") {
                    showEditSheet = false
                }
                .foregroundStyle(.red),
                trailing: Button("Save") {
                    onSave()
                    showEditSheet = false
                }
            )
        }
    }

    // MARK: Private variables
    private var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }

    private var integerFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }

}

#Preview("Light Mode") {
    struct PreviewWrapper: View {
        @State private var showEditSheet = true
        @State private var goalWaterIntake = 64.0
        @State private var goalCaloriesIntake = 2000.0
        @State private var goalProteinIntake = 150.0

        var body: some View {
            EditNutritionGoalsSheet(
                showEditSheet: $showEditSheet,
                goalWaterIntake: $goalWaterIntake,
                goalCaloriesIntake: $goalCaloriesIntake,
                goalProteinIntake: $goalProteinIntake,
                onSave: {
                    print("Goals saved")
                }
            )
        }
    }

    return PreviewWrapper()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    struct PreviewWrapper: View {
        @State private var showEditSheet = true
        @State private var goalWaterIntake = 64.0
        @State private var goalCaloriesIntake = 2000.0
        @State private var goalProteinIntake = 150.0

        var body: some View {
            EditNutritionGoalsSheet(
                showEditSheet: $showEditSheet,
                goalWaterIntake: $goalWaterIntake,
                goalCaloriesIntake: $goalCaloriesIntake,
                goalProteinIntake: $goalProteinIntake,
                onSave: {
                    print("Goals saved")
                }
            )
        }
    }

    return PreviewWrapper()
        .preferredColorScheme(.dark)
}
