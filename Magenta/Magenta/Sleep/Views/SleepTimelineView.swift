//
//  SleepTimelineView.swift
//  Magenta
//
//  Created by Sarah Clark on 3/20/25.
//

import HealthKit
import SwiftUI

struct SleepTimelineView: View {
    let samples: [HKCategorySample]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Sleep Timeline")
                .font(.title2.bold())
                .foregroundColor(.white)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 30)

                    ForEach(samples, id: \.uuid) { sample in
                        SleepSegmentView(sample: sample, totalWidth: geometry.size.width)
                    }
                }
            }
            .frame(height: 50)
        }
        .padding()
        .background(Color.indigo.opacity(0.2))
        .cornerRadius(12)
    }
}


