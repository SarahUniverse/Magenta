//
//  LandingPageView.swift
//  Magenta
//
//  Created by Sarah Clark on 4/10/25.
//

import CoreData
import SwiftUI

struct LandingPageView: View {
    @State private var selectedTab: Int = 0
    @State private var index = 0
    let color: [Color] = [.lightPurple, .pinkPurple, .purple4, .darkBlue, .darkPurple]
    private let viewContext: NSManagedObjectContext
    @State private var landingPageViewModel: LandingPageViewModel

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _landingPageViewModel = State(wrappedValue: LandingPageViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                AppGradients.backgroundGradient
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
                        .padding(.top, 20)

                    Image(systemName: "brain.head.profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
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
                            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true ) { _ in
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
                        Text("Manage stress, anxiety, and more with tools like")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .bold()
                        Text("mood tracking, guided meditations, and journaling.")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .bold()
                    }

                    NavigationLink(destination: SignUpView(viewContext: viewContext)) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .padding(.horizontal, 40)
                            .shadow(radius: 5)
                    }

                    TabbedContentView(selectedTab: $selectedTab)
                        .padding(.bottom, 20)
                }
            }
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let context = LandingPageView.createPreviewContext()
    LandingPageView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let context = LandingPageView.createPreviewContext()
    LandingPageView(viewContext: context)
        .preferredColorScheme(.dark)
}

extension LandingPageView {
    static func createPreviewContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack for preview: \(error)")
            }
        }
        return container.viewContext
    }

}
