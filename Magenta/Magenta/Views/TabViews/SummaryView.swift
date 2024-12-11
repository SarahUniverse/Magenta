//
//  SummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct SummaryView: View {
    @State private var showingModal = false

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.lightPurple,
            Color.darkPurple,
            Color.darkBlue,
            Color.black,
            Color.black,
            Color.black,
            Color.black,
            Color.black

        ]),
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )

    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("MENTAL WELLBEING")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)

                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "person.crop.circle.badge.exclamationmark")
                                .foregroundColor(.green)
                                .font(.largeTitle)

                            VStack(alignment: .leading, spacing: 5) {
                                Text("Mental Health Questionnaire")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Divider()
                                Text("Along with regular reflection, assessing your current risk for common conditions can be an important part of caring for your mental health.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Button(action: {
                                    // Action for "Take Questionnaire"
                                }) {
                                    Text("Take Questionnaire")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("HEALTH CHECKLIST")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)

                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.shield")
                                .foregroundColor(.pink)
                                .font(.largeTitle)

                            VStack(alignment: .leading, spacing: 5) {
                                Text("Make sure the Health features on your iPhone and Apple Watch are set up the way you want them.")
                                    .font(.subheadline)
                                    .foregroundColor(.white)

                                Button(action: {
                                    // Action for "Review"
                                }) {
                                    Text("Review")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Pinned")
                                .font(.title)
                                .foregroundColor(.white)

                            Spacer()

                            Button(action: {
                                // Action for "Edit"
                            }) {
                                Text("Edit")
                                    .foregroundColor(.blue)
                            }
                        }

                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.largeTitle)

                            VStack(alignment: .leading, spacing: 5) {
                                Text("Steps")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text("9 steps")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text("12:38 AM")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
            }

            .navigationBarTitle("Summary")
            .navigationBarItems(trailing: Image(systemName: "person.circle"))
            //.foregroundStyle(Color.white)
        }
    }
}

#Preview {
    SummaryView()
}
