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
    @Environment(\.colorScheme) var colorScheme
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

    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(colorScheme == .dark ? 0.3 : 0.5),
                                .white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        .black.opacity(0.1),
                        lineWidth: 1
                    )
                    .blur(radius: 1)
                    .mask(RoundedRectangle(cornerRadius: 15).fill(.black))
            }
            .padding(.top, 10)
    }

    private var todayMood: MoodEntity? {
        moodSummaryViewModel.moods.last(where: {
            Calendar.current.isDate($0.moodDate ?? Date(), inSameDayAs: Date())
        })
    }

    var body: some View {
        let weekDates = getWeekDates()

        NavigationLink(destination: MoodView(viewContext: viewContext)) {
            VStack(alignment: .leading) {
                Text("MOOD")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                    .padding(.leading, 5)
                    .padding(.bottom, -20)

                HStack(alignment: .center, spacing: 15) {
                    VStack {
                        Text(todayMood != nil ? "Today: \(todayMood?.mood ?? "Unknown")" : "No mood logged today")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .padding(.bottom, 10)
                        ZStack {
                            Circle()
                                .frame(width: 90, height: 90)
                                .rotationEffect(.degrees(-90))
                                .foregroundStyle(.gray.opacity(0.3))
                            Circle()
                                .trim(from: 0, to: todayMood != nil ? CGFloat((todayMood?.moodValue ?? 0) / 10) : 0)
                                .stroke(barGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .frame(width: 90, height: 90)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 1.0), value: todayMood?.moodValue)
                            Text(todayMood?.moodEmoji ?? "😶")
                                .font(.system(size: 30))
                        }
                    }
                    Spacer()
                    VStack {
                        HStack {
                            Spacer()
                            Text("This week")
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                                .padding(.bottom, 10)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.gray)
                                .padding(.bottom, 10)
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
                        .frame(height: 90)
                        .chartYScale(domain: 0...10)
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        .chartXScale(domain: weekDates.first!...weekDates.last!)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                    }
                }
                .padding(30)
                .background(glassBackground)
            }
        }
        .onAppear {
            moodSummaryViewModel.refreshChart()
        }
    }

    private func getWeekDates() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (-7...0).map { offset in
            calendar.date(byAdding: .day, value: offset, to: today)!
        }
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
        MoodSummaryView(viewContext: context)
    }
    .preferredColorScheme(.dark)
}
