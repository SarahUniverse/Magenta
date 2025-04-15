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
    @State private var moodViewModel: MoodViewModel
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _moodViewModel = State(wrappedValue: MoodViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: MoodView(viewContext: viewContext)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("MOOD")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(UIColor.secondaryLabel))
                    .padding(.leading, 5)
                    .padding(.bottom, -20)

                HStack {
                    VStack {
                        Text(todayMood != nil ? "Today: \(todayMood?.mood ?? "Unknown")" : "No mood logged today")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .padding(.bottom, 5)
                        ZStack {
                            Circle()
                                .frame(width: 65, height: 65)
                                .rotationEffect(.degrees(-90))
                                .foregroundStyle(.gray.opacity(0.3))
                            Circle()
                                .trim(from: 0, to: todayMood != nil ? CGFloat((todayMood?.moodValue ?? 0) / 10) : 0)
                                .stroke(AppGradients.summaryIconGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .frame(width: 65, height: 65)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 1.0), value: todayMood?.moodValue)
                            Text(todayMood?.moodEmoji ?? "😶")
                                .font(.system(size: 30))
                                .animation(.easeInOut(duration: 1.0), value: todayMood?.moodEmoji)
                        }
                    }
                    VStack {
                        HStack {
                            Spacer()
                            Text(lastMoodDateString)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            NavigationChevron()
                        }
                        moodChart
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(GlassBackground())
            }
        }
        .onAppear {
            moodViewModel.fetchWeekOfMoods()
        }
    }

    // MARK: - Private variables
    private var moodChart: some View {
        let weekDates = getWeekDates()
        return Chart {
            ForEach(moodViewModel.moodsEntity) { daily in
                BarMark(
                    x: .value("Day", daily.moodDate ?? Date(), unit: .day),
                    y: .value("Mood", daily.moodValue)
                )
                .foregroundStyle(AppGradients.discoverIconGradient)
                .cornerRadius(2)
            }
        }
        .frame(height: 80)
        .chartYScale(domain: 0...10)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartXScale(domain: weekDates.first!...weekDates.last!)
        .padding(.trailing, 10)
    }

    private var todayMood: MoodEntity? {
        moodViewModel.moodsEntity.last(where: {
            Calendar.current.isDate($0.moodDate ?? Date(), inSameDayAs: Date())
        })
    }

    private var lastMoodDateString: String {
        guard let lastMood = moodViewModel.moodsEntity.last,
              let moodDate = lastMood.moodDate else {
            return "No moods logged"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: moodDate)
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

    return NavigationStack {
        MoodSummaryView(viewContext: context)
    }
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

    return NavigationStack {
        return MoodSummaryView(viewContext: context)
    }
    .preferredColorScheme(.dark)
}

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
