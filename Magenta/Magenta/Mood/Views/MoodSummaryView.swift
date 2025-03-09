//
//  MoodSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import Charts
import CoreData
import SwiftUI

struct MoodSummaryView: View {
    @StateObject private var moodSummaryViewModel: MoodSummaryViewModel
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _moodSummaryViewModel = StateObject(wrappedValue: MoodSummaryViewModel(viewContext: viewContext))
    }

    private let barGradient = Gradient(colors: [
        .yellow,
        .yellow.opacity(0.7),
        .blue.opacity(0.7),
        .blue.opacity(0.3)
    ])

    var body: some View {
        let weekDates = getWeekDates()

        VStack(alignment: .leading, spacing: 10) {
            Text("MOOD")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "theatermasks.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .font(.largeTitle)
            }

            Chart {
                ForEach(moodSummaryViewModel.moods) { daily in
                    BarMark(
                        x: .value("Day", daily.moodDate ?? Date(), unit: .day),
                        y: .value("Mood", daily.moodValue)
                    )
                    .foregroundStyle(barGradient)
                    .cornerRadius(2)
                }
            }
            .frame(height: 120)
            .chartYScale(domain: 0...10)
            .chartXAxis {
                AxisMarks(values: weekDates) {
                    AxisTick(length: 2)
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                        .font(.caption2)
                }
            }
            .chartXScale(domain: weekDates.first!...weekDates.last!)
            .chartYAxis {
                AxisMarks(values: [0, 2, 4, 6, 8, 10]) { value in
                    AxisGridLine()
                        .foregroundStyle(.gray)
                    AxisTick(length: 2)
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
                            .font(.caption2)
                    }
                }
            }
            .chartPlotStyle { plotArea in
                plotArea
                    .border(Color.gray, width: 1)
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 3)

            Spacer()
        }
        .padding()
        .background(Color.almostBlack)
        .cornerRadius(10)
    }

    private func getWeekDates() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        return (0...7).map { calendar.date(byAdding: .day, value: $0, to: weekStart)! }
    }
}

// MARK: - Preview Helper
extension MoodSummaryView {
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
    let context = MoodSummaryView.createPreviewContext()

    // Define mood emojis to match MoodView's dictionary
    let moodEmojis: [String: String] = [
        "Excited": "🤩",
        "Happy": "😊",
        "Calm": "😌",
        "Curious": "🤔",
        "Relieved": "😮‍💨",
        "Loved": "🥰",
        "Dread": "😩",
        "Vulnerable": "😶‍🌫️ ",
        "Surprised": "😲",
        "Neutral": "😐",
        "Tired": "😴",
        "Stressed": "😓",
        "Sad": "😢",
        "Anxious": "😰",
        "Worry": "😟",
        "Grief": "🥺",
        "Fear": "😱",
        "Heartbreak": "💔",
        "Lonely": "😔",
        "Angry": "😡"
    ]

    // Add sample data
    let sampleMood1 = MoodEntity(context: context)
    sampleMood1.id = UUID()
    sampleMood1.mood = "Happy"
    sampleMood1.moodEmoji = moodEmojis["Happy"]
    sampleMood1.moodDate = Calendar.current.date(byAdding: .day, value: -4, to: Date())!
    sampleMood1.moodValue = 9.0

    let sampleMood2 = MoodEntity(context: context)
    sampleMood2.id = UUID()
    sampleMood2.mood = "Calm"
    sampleMood2.moodEmoji = moodEmojis["Calm"]
    sampleMood2.moodDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
    sampleMood2.moodValue = 6.0

    let sampleMood3 = MoodEntity(context: context)
    sampleMood3.id = UUID()
    sampleMood3.mood = "Neutral"
    sampleMood3.moodEmoji = moodEmojis["Neutral"]
    sampleMood3.moodDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    sampleMood3.moodValue = 4.0

    let sampleMood4 = MoodEntity(context: context)
    sampleMood4.id = UUID()
    sampleMood4.mood = "Sad"
    sampleMood4.moodEmoji = moodEmojis["Sad"]
    sampleMood4.moodDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    sampleMood4.moodValue = 2.0

    let sampleMood5 = MoodEntity(context: context)
    sampleMood5.id = UUID()
    sampleMood5.mood = "Excited"
    sampleMood5.moodEmoji = moodEmojis["Excited"]
    sampleMood5.moodDate = Date()
    sampleMood5.moodValue = 8.0

    try? context.save()

    return MoodSummaryView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let context = MoodSummaryView.createPreviewContext()

    // Define mood emojis to match MoodView's dictionary
    let moodEmojis: [String: String] = [
        "Excited": "🤩",
        "Happy": "😊",
        "Calm": "😌",
        "Curious": "🤔",
        "Relieved": "😮‍💨",
        "Loved": "🥰",
        "Dread": "😩",
        "Vulnerable": "😶‍🌫️ ",
        "Surprised": "😲",
        "Neutral": "😐",
        "Tired": "😴",
        "Stressed": "😓",
        "Sad": "😢",
        "Anxious": "😰",
        "Worry": "😟",
        "Grief": "🥺",
        "Fear": "😱",
        "Heartbreak": "💔",
        "Lonely": "😔",
        "Angry": "😡"
    ]

    // Add sample data
    let sampleMood1 = MoodEntity(context: context)
    sampleMood1.id = UUID()
    sampleMood1.mood = "Happy"
    sampleMood1.moodEmoji = moodEmojis["Happy"]
    sampleMood1.moodDate = Calendar.current.date(byAdding: .day, value: -4, to: Date())!
    sampleMood1.moodValue = 9.0

    let sampleMood2 = MoodEntity(context: context)
    sampleMood2.id = UUID()
    sampleMood2.mood = "Calm"
    sampleMood2.moodEmoji = moodEmojis["Calm"]
    sampleMood2.moodDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
    sampleMood2.moodValue = 6.0

    let sampleMood3 = MoodEntity(context: context)
    sampleMood3.id = UUID()
    sampleMood3.mood = "Neutral"
    sampleMood3.moodEmoji = moodEmojis["Neutral"]
    sampleMood3.moodDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    sampleMood3.moodValue = 4.0

    let sampleMood4 = MoodEntity(context: context)
    sampleMood4.id = UUID()
    sampleMood4.mood = "Sad"
    sampleMood4.moodEmoji = moodEmojis["Sad"]
    sampleMood4.moodDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    sampleMood4.moodValue = 2.0

    let sampleMood5 = MoodEntity(context: context)
    sampleMood5.id = UUID()
    sampleMood5.mood = "Excited"
    sampleMood5.moodEmoji = moodEmojis["Excited"]
    sampleMood5.moodDate = Date()
    sampleMood5.moodValue = 8.0

    try? context.save()

    return MoodSummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}
