//
//  MeditationSummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 12/11/24.
//

import CoreData
import SwiftUI

struct MeditationSummaryView: View {
    @State private var meditationViewModel: MeditationViewModel
    @State private var isAnimating = false
    @Environment(\.colorScheme) var colorScheme
    let viewContext: NSManagedObjectContext

    private let iconGradient = LinearGradient(
        colors: [.cyan, .darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _meditationViewModel = State(wrappedValue: MeditationViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationLink(destination: MeditationView(viewContext: viewContext)) {
            VStack(alignment: .leading) {
                Text("MEDITATION")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                    .padding(.leading, 5)
                    .padding(.bottom, -20)

                HStack(alignment: .top, spacing: 15) {
                    Image(systemName: "figure.mind.and.body")
                        .foregroundStyle(iconGradient)
                        .font(.system(size: 48))
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                        .onAppear {
                            isAnimating = true
                        }

                    if let selected = meditationViewModel.selectedMeditation {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(selected.meditationTitle)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray)
                            Text("\(selected.meditationDuration) min")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            Text(selected.meditationDescription)
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .lineLimit(2)
                        }
                    } else {
                        Text("No meditation selected")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(20)
                .background(glassBackground)
                .cornerRadius(10)
            }

        }
    }

    // MARK: Private variables
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

}

// For preview only
extension MeditationSummaryView {
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

// MARK: - Previews
#Preview ("Light Mode") {
    let context = MeditationSummaryView.createPreviewContext()
    MeditationSummaryView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = MeditationSummaryView.createPreviewContext()
    MeditationSummaryView(viewContext: context)
        .preferredColorScheme(.dark)
}
