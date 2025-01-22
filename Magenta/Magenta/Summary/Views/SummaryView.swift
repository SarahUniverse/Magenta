//
//  SummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import SwiftUI
import UIKit

struct SummaryView: View {
    @StateObject var summaryViewModel: SummaryViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var showEditPinnedView = false

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.darkPurple,
            Color.darkBlue,
            Color.black,
            Color.black,
            Color.black,
            Color.black,
            Color.black
        ]),
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        _summaryViewModel = StateObject(wrappedValue: SummaryViewModel(viewContext: viewContext, colorScheme: colorScheme))
    }

    // MARK: - Main View
    var body: some View {
        NavigationStack {
                VStack {
                    HStack {
                        Spacer()
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                if summaryViewModel.pinnedItems.contains("Art Therapy") {
                                    ArtTherapySummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Journal") {
                                    JournalSummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Exercise") {
                                    ExerciseSummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Mood") {
                                    MoodSummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Sleep") {
                                    SleepSummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Nutrition") {
                                    NutritionSummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Books") {
                                    BooksSummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Playlists") {
                                    PlaylistsSummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Quotes") {
                                    QuotesSummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Therapist") {
                                    TherapistSummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Meditation") {
                                    MeditationSummaryView()
                                }
                                if summaryViewModel.pinnedItems.contains("Cycle") {
                                    CycleSummaryView()
                                }
                            }
                            .padding()
                        }
                    }
                }
                .background(backgroundGradient)
                .onChange(of: colorScheme) {
                    summaryViewModel.updateColorScheme($1)
                }
                .scrollContentBackground(.hidden)
                .fullScreenCover(isPresented: $summaryViewModel.shouldShowLoginView) {
                    LoginView(viewContext: summaryViewModel.viewContext)
                }
                .sheet(isPresented: $showEditPinnedView) {
                    EditPinnedView()
                        .onDisappear {
                            // Update pinned items when the sheet is dismissed
                            summaryViewModel.pinnedItems = EditPinnedView().editPinnedViewModel.pinnedItems
                        }
                }
                .navigationBarTitle("Summary")
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            summaryViewModel.signOut()
                        }, label: {
                            Text("Sign Out")
                                .padding(8)
                                .cornerRadius(20)
                                .foregroundStyle(summaryViewModel.colors.textColor)
                        })
            )
        }
    }

    // MARK: - Private functions
    private func iconColor() -> Color {
        colorScheme == .dark ? .white : .black
    }

    private func signOutButtonColor() -> Color {
        colorScheme == .dark ? .white : .black
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    return SummaryView(viewContext: persistentContainer.viewContext, colorScheme: .light)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    return SummaryView(viewContext: persistentContainer.viewContext, colorScheme: .dark)
        .preferredColorScheme(.dark)
}
