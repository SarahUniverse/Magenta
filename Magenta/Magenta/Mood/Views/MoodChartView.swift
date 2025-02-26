//
//  MoodChartView.swift
//  Magenta
//
//  Created by Sarah Clark on 2/17/25.
//

import Charts
import SwiftUI

struct MoodChartView: View {
    @StateObject private var viewModel = MoodChartViewModel()

    var body: some View {
        VStack(alignment: .center) {
            Chart {
                ForEach(viewModel.dailyMoods) { daily in
                    LineMark(
                        x: .value("Date", daily.moodDate),
                        y: .value("Mood", daily.moodValue)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol(Circle())
                    .symbolSize(30)
                    .foregroundStyle(Gradient(colors: [.blue, .blue.opacity(0.5)]))

                    AreaMark(
                        x: .value("Date", daily.moodDate),
                        y: .value("Mood", daily.moodValue)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Gradient(colors: [.blue.opacity(0.2), .blue.opacity(0.05)]))
                }
            }
            .frame(height: 300)
            .chartYScale(domain: 0...10)
            .chartYAxis {
                AxisMarks(values: [1.2, 2.5, 3.5, 5.0, 6.5, 7.0, 8.0, 9.0]) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(viewModel.getMoodLabel(for: doubleValue))
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.weekday())
                }
            }
            .padding()
        }
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

// MARK: - Previews
#Preview("Light Mode") {
        MoodChartView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    MoodChartView()
        .preferredColorScheme(.dark)
}
