//
//  SummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import SwiftUI

struct SummaryView: View {
    @StateObject var summaryViewModel: SummaryViewModel
    @Environment(\.colorScheme) var colorScheme

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.lightPurple,
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

    init(viewContext: NSManagedObjectContext) {
        _summaryViewModel = StateObject(wrappedValue: SummaryViewModel(viewContext: viewContext))
    }

    // MARK: - Main View Code
    var body: some View {
        NavigationView {
            HStack {
                Spacer()
                Button(action: {
                    summaryViewModel.signOut()
                }, label: {
                    HStack {
                        Text("Sign Out")
                            .font(.title)
                    }
                    .padding(.trailing, 30)
                    .foregroundStyle(signOutButtonColor())
                })
            }
                ZStack {
                    backgroundGradient
                        .edgesIgnoringSafeArea(.all)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ExerciseSummary()
                            SleepSummaryView()
                            NutritionSummaryView()
                            MeditationSummaryView()
                        }
                        .padding()
                    }
                    .navigationBarTitle("Summary")
                    .navigationBarItems(trailing: Image(systemName: "person.circle"))
                    .foregroundStyle(iconColor())
                }
            }
        .fullScreenCover(isPresented: $summaryViewModel.shouldShowLoginView) {
            LoginView(viewContext: summaryViewModel.viewContext)
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

// MARK: Previews
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

    return SummaryView(viewContext: persistentContainer.viewContext)
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

    return SummaryView(viewContext: persistentContainer.viewContext)
        .preferredColorScheme(.dark)
}
