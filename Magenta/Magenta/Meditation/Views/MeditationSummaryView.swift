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

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: MeditationView(viewContext: viewContext)) {
            contentView
        }
    }

    // MARK: Private Variables
    private var contentView: some View {
        VStack(alignment: .leading) {
            titleText
            meditationContent
        }
    }

    private var titleText: some View {
        Text("MEDITATION")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.gray)
            .padding(.leading, 5)
            .padding(.bottom, -20)
    }

    private var meditationContent: some View {
        HStack(alignment: .top, spacing: 15) {
            meditationIcon
            meditationDetails
        }
        .padding(20)
        .padding(.top, 15)
        .background(glassBackground)
    }

    private var meditationIcon: some View {
        ZStack {
            Circle()
                .fill(Color.indigo.opacity(0.3))
                .frame(width: 70, height: 70)
                .shadow(radius: 5)

            Image(systemName: "figure.mind.and.body")
                .foregroundStyle(iconGradient)
                .font(.system(size: 48))
                .shadow(radius: 5)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }

    private var meditationDetails: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let selected = meditationViewModel.selectedMeditation {
                meditationHeader
                Text(selected.meditationTitle)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                meditationDuration
                Text(selected.meditationDescription)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            } else {
                Text("No meditation selected")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
    }

    private var meditationHeader: some View {
        HStack {
            Text("Currently listening to:")
                .font(.caption)
                .foregroundStyle(.gray)
            navigationChevron
        }
    }

    private var meditationDuration: some View {
        HStack {
            Text("\(meditationViewModel.selectedMeditation?.meditationDuration ?? 0) min")
                .font(.subheadline)
                .foregroundStyle(.gray)
            Image(systemName: "clock")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }

    private var navigationChevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.blue)
            .padding(.bottom, 70)
    }

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
