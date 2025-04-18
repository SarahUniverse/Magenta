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
                        Text("Weight Goal (lbs)")
                        Spacer()
                        TextField("Water goal", value: $goalWaterIntake, formatter: decimalFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Text("Calorie Intake Goal")
                        Spacer()
                        TextField("Reps", value: $goalCaloriesIntake, formatter: integerFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Duration Goal (min)")
                        Spacer()
                        TextField("Duration", value: $goalProteinIntake, formatter: integerFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .navigationTitle("Edit Nutrition goals")
            .navigationBarItems(
                leading: Button("Cancel") {
                    showEditSheet = false
                },
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

/*
#Preview {
    EditNutritionGoalsSheet(showEditSheet: <#Binding<Bool>#>, goalWaterIntake: <#Binding<Double>#>, goalCaloriesIntake: <#Binding<Double>#>, goalProteinIntake: <#Binding<Double>#>, onSave: <#() -> Void#>)
}
*/
