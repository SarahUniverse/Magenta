//
//  SleepView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//
import SwiftUI

struct SleepView: View {
    @State var sleepViewModel: SleepViewModel

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

    var body: some View {
        NavigationStack {
            if sleepViewModel.hasOptedIntoSleepTracking {
                List {
                    Text("Hello, World!")
                }
                .navigationTitle("Sleep Tracking")
                .background(backgroundGradient)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: "person.circle")
                    }
                }
            } else {
                SleepTrackingOptInScreen(sleepViewModel: sleepViewModel)
            }
        }
    }
}

// MARK: - Previews
#Preview("Light Mode - Opted In") {
    let sleepViewModel = SleepViewModel(healthKitManager: HealthKitManager.shared)
    sleepViewModel.hasOptedIntoSleepTracking = true // Simulate opted-in state
    return SleepView(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.light)
}

#Preview("Light Mode - Not Opted In") {
    let sleepViewModel = SleepViewModel(healthKitManager: HealthKitManager.shared)
    sleepViewModel.hasOptedIntoSleepTracking = false // Simulate not opted-in state
    return SleepView(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode - Opted In") {
    let sleepViewModel = SleepViewModel(healthKitManager: HealthKitManager.shared)
    sleepViewModel.hasOptedIntoSleepTracking = true // Simulate opted-in state
    return SleepView(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.dark)
}

#Preview("Dark Mode - Not Opted In") {
    let sleepViewModel = SleepViewModel(healthKitManager: HealthKitManager.shared)
    sleepViewModel.hasOptedIntoSleepTracking = false // Simulate not opted-in state
    return SleepView(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.dark)
}
