//
//  SleepDetainRow.swift
//  Magenta
//
//  Created by Sarah Clark on 3/20/25.
//

import HealthKit
import SwiftUI

struct SleepDetailRow: View {
    let sample: HKCategorySample
    let timeFormatter: DateFormatter

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Circle()
                    .fill(sleepColor(for: sample.value))
                    .frame(width: 10, height: 10)
                Text(sleepStateName(for: sample.value))
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Text("Start: \(timeFormatter.string(from: sample.startDate))")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Text("End: \(timeFormatter.string(from: sample.endDate))")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Text("Duration: \(String(format: "%.1f", sample.endDate.timeIntervalSince(sample.startDate) / 3600)) hours")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Text("Source: \(sample.sourceRevision.source.name)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
            if let metadata = sample.metadata, !metadata.isEmpty {
                Text("Metadata: \(metadataDescription(metadata))")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.vertical, 5)
    }

    func sleepStateName(for value: Int) -> String {
        switch HKCategoryValueSleepAnalysis(rawValue: value) {
        case .inBed: return "In Bed"
        case .asleep: return "Asleep (Unspecified)"
        case .awake: return "Awake"
        case .asleepCore: return "Core Sleep"
        case .asleepDeep: return "Deep Sleep"
        case .asleepREM: return "REM Sleep"
        default: return "Unknown"
        }
    }

    func sleepColor(for value: Int) -> Color {
        switch HKCategoryValueSleepAnalysis(rawValue: value) {
        case .inBed: return .gray
        case .asleep: return .blue
        case .awake: return .red
        case .asleepCore: return .cyan
        case .asleepDeep: return .purple
        case .asleepREM: return .green
        default: return .gray
        }
    }

    func metadataDescription(_ metadata: [String: Any]) -> String {
        metadata.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
    }

}
