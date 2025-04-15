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
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _meditationViewModel = State(wrappedValue: MeditationViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: MeditationView(viewContext: viewContext)) {
            VStack(alignment: .leading, spacing: 10) {
                titleText
                meditationContent
            }
        }
    }

    // MARK: Private Variables
    private var titleText: some View {
        Text("MEDITATION")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(AppGradients.summaryTitleTextGradient)
            .padding(.leading, 5)
            .padding(.bottom, -20)
            .shadow(radius: 2, y: 1)
    }

    private var meditationContent: some View {
        HStack(alignment: .center, spacing: 10) {
            meditationIcon
            meditationDetails
        }
        .padding(25)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GlassBackground())
    }

    private var meditationIcon: some View {
        ZStack {
            Circle()
                .fill(Color.indigo.opacity(0.3))
                .frame(width: 70, height: 70)
                .shadow(radius: 5)

            Image(systemName: "figure.mind.and.body")
                .foregroundStyle(AppGradients.summaryIconGradient)
                .font(.system(size: 48))
                .shadow(radius: 5)
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
            Spacer()
            NavigationChevron()
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
