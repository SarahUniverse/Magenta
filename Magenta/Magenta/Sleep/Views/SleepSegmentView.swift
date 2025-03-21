//
//  SleepSegmentView.swift
//  Magenta
//
//  Created by Sarah Clark on 3/20/25.
//

import HealthKit
import SwiftUI

struct SleepSegmentView: View {
    let sample: HKCategorySample
    let totalWidth: CGFloat

    var body: some View {
        let duration = sample.endDate.timeIntervalSince(sample.startDate)
        let totalDaySeconds = 24 * 60 * 60.0 // 24 hours in seconds
                                             // Use Calendar.current.startOfDay(for:) instead of startOfDay()
        let startOfDay = Calendar.current.startOfDay(for: sample.startDate)
        let offset = (sample.startDate.timeIntervalSince(sample.startDate.startOfDay()) / totalDaySeconds) * Double(totalWidth)
        let width = (duration / totalDaySeconds) * Double(totalWidth)

        Rectangle()
            .fill(sleepColor(for: sample.value))
            .frame(width: width, height: 30)
            .offset(x: offset)
    }

    func sleepColor(for value: Int) -> Color {
        switch HKCategoryValueSleepAnalysis(rawValue: value) {
        case .inBed: return .gray.opacity(0.5)
        case .asleep: return .blue.opacity(0.7)
        case .awake: return .red.opacity(0.5)
        case .asleepCore: return .cyan.opacity(0.7)
        case .asleepDeep: return .purple.opacity(0.7)
        case .asleepREM: return .green.opacity(0.7)
        default: return .gray
        }
    }

}
