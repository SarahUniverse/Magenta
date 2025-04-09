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
    @State var summaryViewModel: SummaryViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var showEditPinnedView = false

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .darkPurple.opacity(0.5), location: 0),
            Gradient.Stop(color: .darkPurple.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .darkBlue.opacity(0.7), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        _summaryViewModel = State(wrappedValue: SummaryViewModel(viewContext: viewContext, colorScheme: colorScheme))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Pinned")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                    Button(action: {
                        showEditPinnedView = true
                    }, label: {
                        Text("Edit")
                            .foregroundStyle(.blue)
                    })
                }
                .padding([.leading, .trailing, .top])

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(summaryViewModel.pinnedItems, id: \.self) { item in
                        switch item {
                            case "Art Therapy":
                                ArtTherapySummaryView(viewContext: summaryViewModel.viewContext)
                            case "Journal":
                                JournalSummaryView(viewContext: summaryViewModel.viewContext)
                            case "Exercise":
                                ExerciseSummaryView(viewContext: summaryViewModel.viewContext)
                            case "Mood":
                                MoodSummaryView(viewContext: summaryViewModel.viewContext)
                            case "Sleep":
                                SleepSummaryView(viewContext: summaryViewModel.viewContext)
                            case "Nutrition":
                                NutritionSummaryView(viewContext: summaryViewModel.viewContext)
                            case "Books":
                                BooksSummaryView(viewContext: summaryViewModel.viewContext)
                            case "Music":
                                PlaylistsSummaryView(viewContext: summaryViewModel.viewContext)
                            case "Quotes":
                                QuotesSummaryView(viewContext: summaryViewModel.viewContext)
                            case "Therapy":
                                TherapistSummaryView(viewContext: summaryViewModel.viewContext)
                            case "Meditation":
                                MeditationSummaryView(viewContext: summaryViewModel.viewContext)
                            case "Cycle":
                                CycleSummaryView()
                            default:
                                EmptyView()
                        }
                    }
                }
                .padding()
            }
        }
        .background(backgroundGradient)
        .scrollContentBackground(.hidden)
        .onChange(of: colorScheme) {
            summaryViewModel.updateColorScheme($1)
        }
        .fullScreenCover(isPresented: $summaryViewModel.shouldShowLoginView) {
            LoginView(viewContext: summaryViewModel.viewContext)
        }
        .sheet(isPresented: $showEditPinnedView) {
            EditPinnedView(pinnedItems: $summaryViewModel.pinnedItems, summaryViewModel: summaryViewModel)
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
