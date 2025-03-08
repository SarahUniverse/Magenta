//
//  MoodView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

struct MoodView: View {
    @StateObject private var moodViewModel: MoodViewModel
    @State private var isAnimating = false
    @State private var selectedMood: String?
    @State private var showingMoodDetail = false
    @State private var moodHasBeenLoggedToday = false
    @Environment(\.colorScheme) var colorScheme
    @State private var currentMoodText = "How are you feeling today?"
    @StateObject private var moodChartViewModel: MoodChartViewModel
    // MARK: - Animations
    @State private var moodSectionOffset: CGFloat = 30
    @State private var chartSectionOffset: CGFloat = 30
    @State private var opacity: Double = 0
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _moodViewModel = StateObject(wrappedValue: MoodViewModel(viewContext: viewContext))
        _moodChartViewModel = StateObject(wrappedValue: MoodChartViewModel(moodViewModel: MoodViewModel(viewContext: viewContext)))
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                HStack(spacing: 15) {
                    ForEach(moodViewModel.items, id: \.self) { mood in
                        IndividualMoodView(
                            mood: mood,
                            emoji: moodEmojis[mood] ?? "😊",
                            isSelected: selectedMood == mood
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                selectedMood = mood
                                showingMoodDetail = true
                                moodHasBeenLoggedToday = true
                                currentMoodText = "Today's mood is: \(mood)"
                                moodViewModel.saveMoodToCoreData(mood: mood, emoji: moodEmojis[mood] ?? "😊")
                            }
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var profileButton: some View {
        Button(action: {
            // Add profile action
        }, label: {
            Image(systemName: "person.circle")
                .font(.title2)
                .foregroundColor(.white)
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
            .padding(.horizontal)
            .padding(.top)

            MoodChartView(viewContext: viewContext, moodViewModel: moodViewModel)
                .padding(.horizontal, 5)
                .onChange(of: moodViewModel.moods) {
                    // Refresh chart when moods change{
                    moodChartViewModel.refreshChart()
                }
        }
        .background {
            glassBackground
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
            MoodChartView(viewContext: viewContext, moodViewModel: moodViewModel)
            Spacer()
            Spacer()
        }
        .background(glassBackground)
    }

    // MARK: - Animation Methods
    private func animateContent() {
        // Staggered animation for sections
        withAnimation(.spring(
            response: AnimationConstants.springResponse,
            dampingFraction: AnimationConstants.springDamping,
            blendDuration: 1)
        ) {
            isAnimating = true
        }

        // Animate sections with delay
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
            glassBackground
        }
        .offset(y: isAnimating ? 0 : moodSectionOffset)
        .opacity(isAnimating ? 1 : 0)
        .padding(.horizontal)
    }

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
                // Subtle inner shadow
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

    // MARK: - Main View
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
    return MoodView(viewContext: context)
        .environment(\.managedObjectContext, context)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let context = MoodView.createPreviewContext()
    return MoodView(viewContext: context)
        .environment(\.managedObjectContext, context)
        .preferredColorScheme(.dark)
}
