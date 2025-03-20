//
//  SleepTrackingOptInScreen.swift
//  Magenta
//
//  Created by Sarah Clark on 3/18/25.
//

import SwiftUI
import CoreData

struct SleepTrackingOptInScreen: View {
    @State var sleepViewModel: SleepViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Image(systemName: "moon.zzz.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.mediumBlue, .indigo],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Enable Sleep Tracking")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Allow Magenta to access your sleep data from HealthKit to provide personalized insights and improve your experience. Data is handled securely and privately.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                if let error = sleepViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button(action: {
                    sleepViewModel.requestSleepTrackingAuthorization()
                    if sleepViewModel.isAuthorizationGranted {
                        dismiss()
                    }
                }, label: {
                    Text("Opt In")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(sleepViewModel.isAuthorizationGranted ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                .padding(.horizontal, 40)
                .disabled(sleepViewModel.isAuthorizationGranted)

                Button(action: {
                    dismiss()
                }, label: {
                    Text("Not Now")
                        .foregroundColor(.gray)
                })

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }, label: {
                Text("Cancel")
                    .foregroundColor(.red)
            }))
        }
    }

}

// MARK: Previews
#Preview("Light Mode") {
    let sleepViewModel = SleepViewModel(healthKitManager: HealthKitManager.shared)
    return SleepTrackingOptInScreen(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let sleepViewModel = SleepViewModel(healthKitManager: HealthKitManager.shared)
    return SleepTrackingOptInScreen(sleepViewModel: sleepViewModel)
        .preferredColorScheme(.dark)
}
