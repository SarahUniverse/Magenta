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
    @State var moodViewModel: MoodViewModel
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _moodViewModel = State(wrappedValue: MoodViewModel(viewContext: viewContext))
    }

    private let barGradient = Gradient(colors: [
        .yellow,
        .yellow.opacity(0.7),
        .blue.opacity(0.7),
        .blue.opacity(0.3)
    ])

    var body: some View {
        let weekDates = getWeekDates()

        VStack(alignment: .center, spacing: 10) {
            Chart {
                ForEach(moodViewModel.moods) { daily in
                    BarMark(
                        x: .value("Day", daily.moodDate, unit: .day),
                        y: .value("Mood", daily.moodValue)
                    )
                    .foregroundStyle(barGradient)
                    .symbol(by: .value("Mood", daily.moodValue))
                    .cornerRadius(4)
                }
            }
            .frame(height: 280)
            .chartYScale(domain: 0...10)
            .chartXAxis {
                AxisMarks(values: weekDates) {
                    AxisTick()
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                }
            }
            .chartXScale(domain: weekDates.first!...weekDates.last!)
            .chartYAxis {
                AxisMarks(values: [0, 2, 4, 6, 8, 10]) { value in
                    AxisGridLine()
                        .foregroundStyle(.gray)
                    AxisTick()
                    AxisValueLabel {
                        let moodValue = value.as(Int.self) ?? 0
                        let moodString: String = {
                            switch moodValue {
                                case 0: return "Terrible"
                                case 2: return "Bad"
                                case 4: return "Okay"
                                case 6: return "Good"
                                case 8: return "Great"
                                case 10: return "Amazing"
                                default: return "\(moodValue)"
                            }
                        }()
                        Text(moodString)
                    }
                }
            }
            .chartLegend(.visible)
            .chartPlotStyle { plotArea in
                plotArea.frame(width: 300, height: 300)
                    .border(Color.gray, width: 1)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
        .frame(maxWidth: .infinity)
    }

    private func getWeekDates() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (-7...0).map { offset in
            calendar.date(byAdding: .day, value: offset, to: today)!
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let context = MoodChartView.createPreviewContext()
    let moodViewModel = MoodViewModel(viewContext: context)

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
    moodViewModel.fetchMoodsFromCoreData()

    return MoodChartView(viewContext: context)
        .preferredColorScheme(.light)
        .padding(30)
}

#Preview("Dark Mode") {
    let context = MoodChartView.createPreviewContext()
    let moodViewModel = MoodViewModel(viewContext: context)

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
    moodViewModel.fetchMoodsFromCoreData()

    return MoodChartView(viewContext: context)
        .preferredColorScheme(.dark)
        .padding(30)
}

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
