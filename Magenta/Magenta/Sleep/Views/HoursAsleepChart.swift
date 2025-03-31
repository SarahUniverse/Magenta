//
//  HoursAsleepChart.swift
//  Magenta
//
//  Created by Sarah Clark on 3/20/25.
//

import HealthKit
import SwiftUI
import Charts

struct HoursAsleepChart: View {
    let samples: [HKCategorySample]
    private let calendar = Calendar.current

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d" // e.g., "Mar 13"
        return formatter
    }()

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hours Slept Per Day")
                .font(.headline)
                .foregroundColor(.white)

            Chart {
                ForEach(calculateDailySleepHours().sorted(by: { $0.key < $1.key }), id: \.key) { date, hours in
                    BarMark(
                        x: .value("Date", date, unit: .day),
                        y: .value("Hours", hours)
                    )
                    .foregroundStyle(Color.indigo.opacity(0.7))
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                }
            }
            .chartYAxis {
                AxisMarks(values: .stride(by: 2.0)) { _ in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .frame(height: 200)
        }
        .padding()
        .background(GlassBackground())
        .cornerRadius(12)
    }

    // MARK: - Private Functions
    private func calculateDailySleepHours() -> [Date: Double] {
        var dailyHours: [Date: Double] = [:]

        for sample in samples {
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
