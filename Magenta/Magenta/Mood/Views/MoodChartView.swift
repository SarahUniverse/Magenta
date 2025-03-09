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

    // Gradient matching MoodView's theme
    private let barGradient = Gradient(colors: [
        .yellow,
        .yellow.opacity(0.7),
        .blue.opacity(0.7),
        .blue.opacity(0.3)
    ])

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack {
                // Blue frame as the background
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(height: 300)

                Chart {
                    ForEach(moodChartViewModel.moods) { daily in
                        BarMark(
                            x: .value("Day", daily.moodDate),
                            y: .value("Mood", daily.moodValue)
                        )
                        .foregroundStyle(barGradient)
                        .cornerRadius(4)
                    }
                }
                .frame(height: 280) // Slightly less than the frame to account for border and padding
                .chartYScale(domain: 0...10)
                .chartXAxis {
                    AxisMarks(values: moodChartViewModel.moods.map { $0.moodDate }) { value in
                        AxisGridLine()
                        AxisTick(length: 4) // Reduced length to fit inside
                        AxisValueLabel(centered: true, anchor: .center) {
                            if let date = value.as(Date.self) {
                                Text(date, format: .dateTime.weekday(.abbreviated))
                                    .font(.caption) // Smaller font to prevent overflow
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(values: [1.2, 2.5, 3.5, 5.0, 6.5, 7.0, 8.0, 9.0]) { value in
                        AxisGridLine()
                        AxisTick(length: 4) // Reduced length to fit inside
                        AxisValueLabel(centered: true, anchor: .center) {
                            if let doubleValue = value.as(Double.self) {
                                Text(moodChartViewModel.getMoodLabel(for: doubleValue))
                                    .font(.caption) // Smaller font to prevent overflow
                            }
                        }
                    }
                }
                .chartPlotStyle { plotArea in
                    plotArea
                        .border(Color.clear, width: 0) // Remove internal border to avoid overlap
                }
                .padding(.horizontal, 10) // Increased horizontal padding
                .padding(.vertical, 5) // Adjusted vertical padding
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview Helper
extension MoodChartView {
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

// MARK: - Previews
#Preview("Light Mode") {
    let context = MoodChartView.createPreviewContext()
    let chartViewModel = MoodChartViewModel(viewContext: context)

    // Add sample data
    let sampleMood1 = MoodEntity(context: context)
    sampleMood1.id = UUID()
    sampleMood1.mood = "Happy"
    sampleMood1.moodEmoji = "😊"
    sampleMood1.moodDate = Calendar.current.date(byAdding: .day, value: -4, to: Date())!
    sampleMood1.moodValue = 9.0

    let sampleMood2 = MoodEntity(context: context)
    sampleMood2.id = UUID()
    sampleMood2.mood = "Calm"
    sampleMood2.moodEmoji = "😌"
    sampleMood2.moodDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
    sampleMood2.moodValue = 6.0

    let sampleMood3 = MoodEntity(context: context)
    sampleMood3.id = UUID()
    sampleMood3.mood = "Neutral"
    sampleMood3.moodEmoji = "😐"
    sampleMood3.moodDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    sampleMood3.moodValue = 4.0

    let sampleMood4 = MoodEntity(context: context)
    sampleMood4.id = UUID()
    sampleMood4.mood = "Sad"
    sampleMood4.moodEmoji = "😢"
    sampleMood4.moodDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    sampleMood4.moodValue = 2.0

    let sampleMood5 = MoodEntity(context: context)
    sampleMood5.id = UUID()
    sampleMood5.mood = "Excited"
    sampleMood5.moodEmoji = "🤩"
    sampleMood5.moodDate = Date()
    sampleMood5.moodValue = 8.0

    try? context.save()
    chartViewModel.refreshChart()

    return MoodChartView(viewContext: context)
        .preferredColorScheme(.light)
        .padding(30)
}

#Preview("Dark Mode") {
    let context = MoodChartView.createPreviewContext()
    let chartViewModel = MoodChartViewModel(viewContext: context)

    // Add sample data
    let sampleMood1 = MoodEntity(context: context)
    sampleMood1.id = UUID()
    sampleMood1.mood = "Happy"
    sampleMood1.moodEmoji = "😊"
    sampleMood1.moodDate = Calendar.current.date(byAdding: .day, value: -4, to: Date())!
    sampleMood1.moodValue = 9.0

    let sampleMood2 = MoodEntity(context: context)
    sampleMood2.id = UUID()
    sampleMood2.mood = "Calm"
    sampleMood2.moodEmoji = "😌"
    sampleMood2.moodDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
    sampleMood2.moodValue = 6.0

    let sampleMood3 = MoodEntity(context: context)
    sampleMood3.id = UUID()
    sampleMood3.mood = "Neutral"
    sampleMood3.moodEmoji = "😐"
    sampleMood3.moodDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    sampleMood3.moodValue = 4.0

    let sampleMood4 = MoodEntity(context: context)
    sampleMood4.id = UUID()
    sampleMood4.mood = "Sad"
    sampleMood4.moodEmoji = "😢"
    sampleMood4.moodDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    sampleMood4.moodValue = 2.0

    let sampleMood5 = MoodEntity(context: context)
    sampleMood5.id = UUID()
    sampleMood5.mood = "Excited"
    sampleMood5.moodEmoji = "🤩"
    sampleMood5.moodDate = Date()
    sampleMood5.moodValue = 8.0

    try? context.save()
    chartViewModel.refreshChart()

    return MoodChartView(viewContext: context)
        .preferredColorScheme(.dark)
        .padding(30)
}
