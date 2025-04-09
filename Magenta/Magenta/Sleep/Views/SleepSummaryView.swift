//
//  SleepSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 12/11/24.
//

import Charts
import CoreData
import HealthKit
import SwiftUI

struct SleepSummaryView: View {
    @State var sleepViewModel: SleepViewModel
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _sleepViewModel = State(wrappedValue: SleepViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleText
            sleepNavigationLink
        }
    }

    // MARK: - Private Variables
    private var barGradient = Gradient(colors: [.blue, .indigo])

    private var titleText: some View {
        Text("SLEEP")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.gray)
            .padding(.leading, 5)
            .padding(.bottom, -20)
    }

    private var sleepNavigationLink: some View {
        NavigationLink(destination: SleepView(viewContext: viewContext)) {
            HStack(alignment: .top, spacing: 10) {
                sleepIcon
                Spacer()
                sleepChart
                NavigationChevron()
            }
        }
        .padding(20)
        .background(GlassBackground())
        .cornerRadius(10)
    }

    private var sleepIcon: some View {
        Image(systemName: "moon.zzz")
            .foregroundStyle(
                LinearGradient(
                    colors: [.mediumBlue, .indigo],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .font(.largeTitle)
    }

    private var sleepChart: some View {
        Chart {
            ForEach(calculateDailySleepHours().sorted(by: { $0.key < $1.key }), id: \.key) { date, hours in
                BarMark(
                    x: .value("Date", date, unit: .day),
                    y: .value("Hours", hours)
                )
                .foregroundStyle(barGradient)
            }
        }
        .frame(height: 90)
        .chartYScale(domain: 0...10)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .padding(.horizontal, 5)
        .padding(.vertical, 3)
    }

    // MARK: - Private Functions
    private func calculateDailySleepHours() -> [Date: Double] {
        var dailyHours: [Date: Double] = [:]
        let calendar = Calendar.current

        for sample in sleepViewModel.sleepSamples ?? [] {
            let state = HKCategoryValueSleepAnalysis(rawValue: sample.value)
            // Only count actual sleep states (exclude inBed and awake)
            guard state == .asleepCore || state == .asleepDeep || state == .asleepREM else { continue }

            let startOfDay = calendar.startOfDay(for: sample.startDate)
            let duration = sample.endDate.timeIntervalSince(sample.startDate) / 3600.0 // Convert to hours

            dailyHours[startOfDay, default: 0.0] += duration
        }
        return dailyHours
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
    return SleepSummaryView(viewContext: viewContext)
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
    return SleepSummaryView(viewContext: viewContext)
        .preferredColorScheme(.dark)
}
