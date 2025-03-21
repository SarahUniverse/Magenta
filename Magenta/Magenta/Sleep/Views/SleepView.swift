//
//  SleepView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import HealthKit
import SwiftUI

struct SleepView: View {
    @State var sleepViewModel: SleepViewModel
    let viewContext: NSManagedObjectContext

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .mediumBlue.opacity(0.8), location: 0),
            Gradient.Stop(color: .mediumBlue.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .indigo.opacity(0.6), location: 0.2),
            Gradient.Stop(color: .indigo.opacity(0.4), location: 0.3),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _sleepViewModel = State(wrappedValue: SleepViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationStack {
            // if sleepViewModel.hasOptedIntoSleepTracking {
                ScrollView {
                    VStack(spacing: 20) {
                        SleepTimelineView(samples: sleepViewModel.sleepSamples ?? [])
                        SleepDetailsList(samples: sleepViewModel.sleepSamples ?? [])
                    }
                    .padding()
                }
                .navigationTitle("Sleep Tracking")
                .background(backgroundGradient)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: "person.circle")
                    }
                }
            /*} else {
                SleepTrackingOptInScreen(sleepViewModel: sleepViewModel)
            }*/
        }
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

    let viewContext = persistentContainer.viewContext
    let sleepViewModel = SleepViewModel(viewContext: viewContext, healthKitManager: HealthKitManager.shared)
    sleepViewModel.hasOptedIntoSleepTracking = true

    // Mock sleep sample
    let calendar = Calendar.current
    let now = Date() // March 20, 2025
    let startOfDay = calendar.startOfDay(for: now)
    let sample = HKCategorySample(
        type: HKCategoryType(.sleepAnalysis),
        value: HKCategoryValueSleepAnalysis.asleepCore.rawValue,
        start: calendar.date(byAdding: .hour, value: 23, to: startOfDay)!,
        end: calendar.date(byAdding: .hour, value: 25, to: startOfDay)!,
        device: nil,
        metadata: nil
    )
    sleepViewModel.sleepSamples = [sample]

     return SleepView(viewContext: viewContext)
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

    let viewContext = persistentContainer.viewContext
    let sleepViewModel = SleepViewModel(viewContext: viewContext, healthKitManager: HealthKitManager.shared)
    sleepViewModel.hasOptedIntoSleepTracking = true

    let calendar = Calendar.current
    let now = Date()
    let startOfDay = calendar.startOfDay(for: now)
    let sample = HKCategorySample(
        type: HKCategoryType(.sleepAnalysis),
        value: HKCategoryValueSleepAnalysis.asleepCore.rawValue,
        start: calendar.date(byAdding: .hour, value: 23, to: startOfDay)!,
        end: calendar.date(byAdding: .hour, value: 25, to: startOfDay)!,
        device: nil,
        metadata: nil
    )
    sleepViewModel.sleepSamples = [sample]

    return SleepView(viewContext: viewContext)
        .preferredColorScheme(.dark)
}
