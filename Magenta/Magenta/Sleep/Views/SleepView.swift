//
//  SleepView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import SwiftUI

struct SleepView: View {
    @State var sleepViewModel: SleepViewModel
    let viewContext: NSManagedObjectContext

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

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _sleepViewModel = State(wrappedValue: SleepViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationStack {
            if sleepViewModel.hasOptedIntoSleepTracking {
                ScrollView {
                    VStack(spacing: 20) {
                        SleepSummaryView(viewContext: viewContext)
                        SleepTimelineView(samples: sleepViewModel.sleepSamples ?? [])
                        SleepDetailsList(samples: sleepViewModel.sleepSamples ?? [])
                    }
                    .padding()
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

/*
// MARK: - Previews
#Preview("Light Mode - Opted In") {
    let sleepViewModel = SleepViewModel(healthKitManager: HealthKitManager.shared)
    sleepViewModel.hasOptedIntoSleepTracking = true
    return SleepView(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode - Opted In") {
    let sleepViewModel = SleepViewModel(healthKitManager: HealthKitManager.shared)
    sleepViewModel.hasOptedIntoSleepTracking = true
    return SleepView(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.dark)
}

#Preview("Light Mode - Not Opted In") {
    let sleepViewModel = SleepViewModel(healthKitManager: HealthKitManager.shared)
    sleepViewModel.hasOptedIntoSleepTracking = false
    return SleepView(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode - Not Opted In") {
    let sleepViewModel = SleepViewModel(healthKitManager: HealthKitManager.shared)
    sleepViewModel.hasOptedIntoSleepTracking = false
    return SleepView(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.dark)
}
*/
