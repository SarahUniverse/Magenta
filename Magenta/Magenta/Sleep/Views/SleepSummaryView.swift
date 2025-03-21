//
//  SleepSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 12/11/24.
//

import Charts
import CoreData
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

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                            .font(.subheadline)
                            .foregroundStyle(.white)

                        Button("Review") { }
                            .foregroundStyle(.blue)
                    }
                }
            }
            .padding()
            .background(glassBackground)
            .cornerRadius(10)
        }
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

/*
// MARK: - Previews
#Preview("Light Mode") {
    let healthKitManager = HealthKitManager()
    let sleepViewModel = SleepViewModel(healthKitManager: healthKitManager)
    sleepViewModel.hasOptedIntoSleepTracking = true

    return SleepSummaryView(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let healthKitManager = HealthKitManager()
    let sleepViewModel = SleepViewModel(healthKitManager: healthKitManager)
    sleepViewModel.hasOptedIntoSleepTracking = true

    return SleepSummaryView(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.dark)
}
*/
