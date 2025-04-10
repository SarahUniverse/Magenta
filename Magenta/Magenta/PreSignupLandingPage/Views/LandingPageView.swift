//
//  LandingPageView.swift
//  Magenta
//
//  Created by Sarah Clark on 4/10/25.
//

import SwiftUI

struct LandingPageView: View {
    @State private var selectedTab: Int = 0
    @State private var index = 0
    let color: [Color] = [.lightPurple, .pinkPurple, .purple4, .darkBlue, .darkPurple]

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.lightPurple,
            Color.darkPurple,
            Color.darkBlue,
            Color.black
        ]),
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.4)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Magenta")
                    .font(.system(size: 50, weight: .medium))
                    .contentTransition(.numericText())
                    .frame(width: 250)
                    .shadow(color: color[index], radius: 5)
                    .shadow(color: color[index], radius: 5)
                    .shadow(color: color[index], radius: 50)
                    .shadow(color: color[index], radius: 100)
                    .shadow(color: color[index], radius: 200)
                    .foregroundStyle(Color.white)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true ) { _ in
                            withAnimation {
                                index = (index + 1) % color.count
                            }
                        }
                    }
                    .padding(.top, 30)

                Image(systemName: "brain.head.profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.white.opacity(0.2)))
                    .frame(width: 250)
                    .shadow(color: color[index], radius: 5)
                    .shadow(color: color[index], radius: 5)
                    .shadow(color: color[index], radius: 50)
                    .shadow(color: color[index], radius: 100)
                    .shadow(color: color[index], radius: 200)
                    .foregroundStyle(Color.white)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
                            withAnimation {
                                index = (index + 1) % color.count
                            }
                        }
                    }

                VStack {
                    Text("Welcome to Magenta.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .bold()
                    Text("Your mental health mentor.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .bold()
                    Text("Manage stress, anxiety, and more with tools like mood tracking, guided meditations, and journaling.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .bold()
                }
                Button(action: {
                    print("Sign Up tapped!")
                }, label: {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .padding(.horizontal, 40)
                        .shadow(radius: 5)
                })
                .padding(.top, 20)

                TabbedContentView(selectedTab: $selectedTab)
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 20)
            }
        }
    }

}

#Preview("Light Mode") {
    LandingPageView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    LandingPageView()
        .preferredColorScheme(.dark)
}
