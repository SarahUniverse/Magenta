//
//  LandingPageView.swift
//  Magenta
//
//  Created by Sarah Clark on 4/10/25.
//

import SwiftUI

struct LandingPageView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.pink.opacity(0.6)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // App Logo/Name
                Text("Magenta")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                // Tagline
                Text("Unleash Your Creativity")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))

                Image(systemName: "paintbrush.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.white.opacity(0.2)))

                Text("Magenta is your all-in-one creative hub. Design stunning artwork, edit photos, and share your creations with the world—all in a few taps.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)

                Button(action: {
                    print("Sign Up tapped!")
                }, label: {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.purple)
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
