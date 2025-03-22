//
//  CycleSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct CycleSummaryView: View {
    // @State private var cycleViewModel: CycleViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CYCLE")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.gray)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(.pink)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                        .font(.subheadline)
                        .foregroundStyle(.white)

                    Button("Review") { }
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            .background(Color.almostBlack)
            .cornerRadius(10)
        }
    }
}

// MARK: - Previews
#Preview ("Light Mode") {
    CycleSummaryView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
   CycleSummaryView()
        .preferredColorScheme(.dark)
}
