//
//  SleepSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 12/11/24.
//

import SwiftUI

struct SleepSummaryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SLEEP")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "moon.zzz")
                    .foregroundColor(.darkBlue)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Button("Review") { }
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.almostBlack)
            .cornerRadius(10)
        }
    }
}

#Preview {
    SleepSummaryView()
}
