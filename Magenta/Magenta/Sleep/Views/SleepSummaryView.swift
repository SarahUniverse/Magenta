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
    @Environment(\.colorScheme) var colorScheme
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _sleepViewModel = State(wrappedValue: SleepViewModel(viewContext: viewContext))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SLEEP")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
                .padding(.leading, 5)
                .padding(.bottom, -20)

            NavigationLink(destination: SleepView(viewContext: viewContext)) {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "moon.zzz")
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.mediumBlue, .indigo],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .font(.largeTitle)
                    Spacer()
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
            }
            .padding(20)
            .background(glassBackground)
            .cornerRadius(10)
        }
    }

    private func calculateDailySleepHours() -> [Date: Double] {
        var dailyHours: [Date: Double] = [:]
        let calendar = Calendar.current

        for sample in sleepViewModel.sleepSamples ?? [] { // Use sleepViewModel.sleepSamples
            let state = HKCategoryValueSleepAnalysis(rawValue: sample.value)
            // Only count actual sleep states (exclude inBed and awake)
            guard state == .asleepCore || state == .asleepDeep || state == .asleepREM else { continue }

            let startOfDay = calendar.startOfDay(for: sample.startDate)
            let duration = sample.endDate.timeIntervalSince(sample.startDate) / 3600.0 // Convert to hours

            dailyHours[startOfDay, default: 0.0] += duration
        }

        return dailyHours
    }

    // MARK: - Private Variables
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

    private var barGradient = Gradient(colors: [.blue, .indigo])
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
