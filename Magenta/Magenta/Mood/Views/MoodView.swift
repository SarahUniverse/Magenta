//
//  MoodView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

struct MoodView: View {
    @State private var moodViewModel: MoodViewModel
    @State private var isAnimating = false
    @State private var selectedMood: String?
    @State private var showingMoodDetail = false
    @State private var moodHasBeenLoggedToday = false
    @State private var currentMoodText = "How are you feeling today?"
    @State private var moodChartViewModel: MoodChartViewModel

    // MARK: - Animations
    @State private var moodSectionOffset: CGFloat = 30
    @State private var chartSectionOffset: CGFloat = 30
    @State private var opacity: Double = 0
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _moodViewModel = State(wrappedValue: MoodViewModel(viewContext: viewContext))
        _moodChartViewModel = State(wrappedValue: MoodChartViewModel(viewContext: viewContext))
    }

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .yellow, location: 0),
            Gradient.Stop(color: .yellow.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .blue.opacity(0.7), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

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

    // MARK: - Private Views
    private var titleText: some View {
        Text(currentMoodText)
            .font(.title2)
            .fontWeight(.bold)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : -20)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private var moodScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    HStack(spacing: 15) {
                        ForEach(moodViewModel.items, id: \.self) { mood in
                            IndividualMoodView(
                                mood: mood,
                                emoji: moodEmojis[mood] ?? "😊",
                                isSelected: selectedMood == mood
                            )
                            .id(mood)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    if selectedMood == mood {
                                        selectedMood = nil
                                        if moodViewModel.removeMoodForToday() {
                                            moodHasBeenLoggedToday = false
                                            currentMoodText = "How are you feeling today?"
                                            moodChartViewModel.refreshChart()
                                        }
                                    } else if !moodViewModel.hasMoodForToday() {
                                        selectedMood = mood
                                        showingMoodDetail = true
                                        if moodViewModel.saveMoodToCoreData(mood: mood, emoji: moodEmojis[mood] ?? "😊") {
                                            moodHasBeenLoggedToday = true
                                            currentMoodText = "Today's mood is: \(mood)"
                                            moodChartViewModel.refreshChart()
                                            proxy.scrollTo(mood, anchor: .center)
                                        }
                                    }
                                }
                            }
                            .disabled(moodViewModel.hasMoodForToday() && selectedMood != mood)
                            .opacity(moodViewModel.hasMoodForToday() && selectedMood != mood ? 0.5 : 1.0)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
            }
            .onAppear {
                if let mood = selectedMood {
                    withAnimation {
                        proxy.scrollTo(mood, anchor: .center)
                    }
                }
            }
        }
    }

    private var profileButton: some View {
        Button(action: {
            // Add profile action
        }, label: {
            Image(systemName: "person.circle")
                .font(.title2)
                .foregroundStyle(.white)
        })
    }

    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Weekly Mood Overview")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()

            MoodChartView(viewContext: viewContext)
                .padding(15)
                .padding(.bottom, 20)
                .onChange(of: moodViewModel.moods) {
                    moodChartViewModel.refreshChart()
                }
        }
        .background {
            GlassBackground()
        }
        .offset(y: isAnimating ? 0 : chartSectionOffset)
        .opacity(isAnimating ? 1 : 0)
        .padding(.horizontal)
    }

    private var mainContent: some View {
        VStack(spacing: 10) {
            Spacer()
            titleText
            moodScrollView
            MoodChartView(viewContext: viewContext)
            Spacer()
            Spacer()
        }
        .background(GlassBackground())
    }

    // MARK: - Animation Methods
    private func animateContent() {
        withAnimation(.spring(
            response: AnimationConstants.springResponse,
            dampingFraction: AnimationConstants.springDamping,
            blendDuration: 1)
        ) {
            isAnimating = true
        }

        withAnimation(.spring(
            response: AnimationConstants.springResponse,
            dampingFraction: AnimationConstants.springDamping
        ).delay(AnimationConstants.appearDelay)) {
            moodSectionOffset = 0
            opacity = 1
        }

        withAnimation(.spring(
            response: AnimationConstants.springResponse,
            dampingFraction: AnimationConstants.springDamping
        ).delay(AnimationConstants.appearDelay * 2)) {
            chartSectionOffset = 0
        }
    }

    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            titleText
            moodScrollView
        }
        .padding()
        .background {
            GlassBackground()
        }
        .offset(y: isAnimating ? 0 : moodSectionOffset)
        .opacity(isAnimating ? 1 : 0)
        .padding(.horizontal, 30)
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 10) {
                        moodSection
                        chartSection
                        Spacer()
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Mood Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    profileButton
                }
            }
            .onAppear(perform: animateContent)
            .onAppear {
                moodChartViewModel.refreshChart()
                moodHasBeenLoggedToday = moodViewModel.hasMoodForToday()
                if moodHasBeenLoggedToday, let todayMood = moodViewModel.getTodayMood() {
                    selectedMood = todayMood
                    currentMoodText = "Today's mood is: \(todayMood)"
                } else {
                    selectedMood = nil
                    currentMoodText = "How are you feeling today?"
                }
            }
        }
    }
}

private struct AnimationConstants {
    static let appearDelay = 0.3
    static let springResponse = 0.5
    static let springDamping = 0.65
}

// MARK: - Preview Helpers
extension MoodView {
    static func createPreviewContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }

        return container.viewContext
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let context = MoodView.createPreviewContext()

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
    sampleMood5.moodDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
    sampleMood5.moodValue = 8.0

    try? context.save()

    return MoodView(viewContext: context)
        .environment(\.managedObjectContext, context)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let context = MoodView.createPreviewContext()

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
    sampleMood5.moodDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
    sampleMood5.moodValue = 8.0

    try? context.save()

    return MoodView(viewContext: context)
        .environment(\.managedObjectContext, context)
        .preferredColorScheme(.dark)
}
