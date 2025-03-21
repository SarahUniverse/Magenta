//
//  SleepDetailsList.swift
//  Magenta
//
//  Created by Sarah Clark on 3/20/25.
//

import HealthKit
import SwiftUI

struct SleepDetailsList: View {
    let samples: [HKCategorySample]

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Detailed Breakdown")
                .font(.title2.bold())
                .foregroundColor(.white)

            if samples.isEmpty {
                Text("No sleep data available")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
            } else {
                ForEach(samples, id: \.uuid) { sample in
                    SleepDetailRow(sample: sample, timeFormatter: timeFormatter)
                }
            }
        }
        .padding()
        .background(Color.purple.opacity(0.2)) // Matches SleepTimelineView
        .cornerRadius(12)
    }
}
