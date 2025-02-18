//
//  MoodDetailView.swift
//  Magenta
//
//  Created by Sarah Clark on 2/16/25.
//

import SwiftUI

struct MoodDetailView: View {
    let mood: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("You're feeling \(mood)")
                    .font(.title)
                    .fontWeight(.bold)

                // Add more content specific to the mood
                // Such as suggestions, activities, or journaling prompts

                Button("Log This Mood") {
                    // Add mood logging functionality
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    MoodDetailView(mood: "Excited")
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    MoodDetailView(mood: "Excited")
        .preferredColorScheme(.dark)
}
