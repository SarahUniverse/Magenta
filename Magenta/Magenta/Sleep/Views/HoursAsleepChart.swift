//
//  HoursAsleepChart.swift
//  Magenta
//
//  Created by Sarah Clark on 3/20/25.
//

import HealthKit
import SwiftUI

struct HoursAsleepChart: View {
    let samples: [HKCategorySample]
    private let calendar = Calendar.current

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d" // e.g., "Mar 13"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hours Slept Per Day")
                .font(.headline)
                .foregroundColor(.white)

            let dailyHours = calculateDailySleepHours()
            let maxHours = dailyHours.values.max() ?? 10.0 // Default max of 10 hours if no data

            GeometryReader { geometry in
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(dailyHours.sorted(by: { $0.key < $1.key }), id: \.key) { date, hours in
                        VStack {
                            Text(String(format: "%.1f", hours))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            Rectangle()
                                .fill(Color.cyan.opacity(0.7))
                                .frame(width: geometry.size.width / 7 - 8, height: CGFloat(hours / maxHours) * geometry.size.height * 0.7)
                            Text(dateFormatter.string(from: date))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .frame(height: 200)
            }
            .frame(height: 200)
        }
        .padding()
        .background(Color.purple.opacity(0.2))
        .cornerRadius(12)
    }

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
