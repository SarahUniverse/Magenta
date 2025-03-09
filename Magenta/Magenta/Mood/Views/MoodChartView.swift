//
//  MoodChartView.swift
//  Magenta
//
//  Created by Sarah Clark on 2/17/25.
//

import Charts
import CoreData
import SwiftUI

struct MoodChartView: View {
    @ObservedObject var moodChartViewModel: MoodChartViewModel

    init(viewContext: NSManagedObjectContext) {
        self.moodChartViewModel = MoodChartViewModel(viewContext: viewContext)
    }

    var body: some View {
        VStack(alignment: .center) {
            Chart {
                ForEach(moodChartViewModel.moods) { daily in
                    LineMark(
                        x: .value("Day", daily.moodDate),
                        y: .value("Mood", daily.moodValue)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol(Circle())
                    .symbolSize(30)
                    .foregroundStyle(Gradient(colors: [.blue, .blue.opacity(0.5)]))

                    AreaMark(
                        x: .value("Day", daily.moodDate),
                        y: .value("Mood", daily.moodValue)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Gradient(colors: [.blue.opacity(0.2), .blue.opacity(0.05)]))
                }
            }
            .frame(height: 300)
            .chartYScale(domain: 0...10)
            .chartYAxis {
                AxisMarks(values: [1.2, 2.5, 3.5, 5.0, 6.5, 7.0, 8.0, 9.0]) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(moodChartViewModel.getMoodLabel(for: doubleValue))
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: moodChartViewModel.moods.map { $0.moodDate }) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date, format: .dateTime.weekday(.abbreviated))
                        }
                    }
                }
            }
            .padding()
        }
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

// MARK: - Preview Helper
extension MoodChartView {
    static func createPreviewContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "DataModel") // Replace with your Core Data model name
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") // In-memory store

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack for preview: \(error)")
            }
        }

        return container.viewContext
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let context = MoodChartView.createPreviewContext()
    let chartViewModel = MoodChartViewModel(viewContext: context)
    return MoodChartView(viewContext: context)
        .preferredColorScheme(.light)
        .padding(30)
}

#Preview("Dark Mode") {
    let context = MoodChartView.createPreviewContext()
    let chartViewModel = MoodChartViewModel(viewContext: context)
    return MoodChartView(viewContext: context)
        .preferredColorScheme(.dark)
        .padding(30)
}
