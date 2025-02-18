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

    init(viewContext: NSManagedObjectContext) {
        _moodViewModel = StateObject(wrappedValue: MoodViewModel(viewContext: viewContext))
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
        "Neutral": "😐",
        "Tired": "😴",
        "Sad": "😢",
        "Anxious": "😰",
        "Angry": "😡",
        "Heavy Grief": "🧌"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("How are you feeling today?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : -20)
                        .padding(.top, 40)
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
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    Spacer()
                    MoodChartView()
                        .padding(.horizontal, 5)
                }

            }
            .navigationTitle("Mood Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add profile action
                    }, label: {
                        Image(systemName: "person.circle")
                            .font(.title2)
                            .foregroundColor(.white)
                    })
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    isAnimating = true
                }
            }
        }
    }
}

// MARK: - Previews
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
#Preview ("Light Mode") {
    let context = MoodView.createPreviewContext()
    return MoodView(viewContext: context)
        .environment(\.managedObjectContext, context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = MoodView.createPreviewContext()
    return MoodView(viewContext: context)
        .environment(\.managedObjectContext, context)
        .preferredColorScheme(.dark)
}
