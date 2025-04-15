//
//  MeditationView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

struct MeditationView: View {
    @State private var meditateViewModel: MeditationViewModel
    @State private var showAddMeditationSheet: Bool = false
    @State private var newMeditationTitle = ""
    @State private var newMeditationDuration: Float = 5
    @State private var newMeditationDescription: String = ""
    @State private var newMeditationURL: String = ""

    init(viewContext: NSManagedObjectContext) {
        _meditateViewModel = State(wrappedValue: MeditationViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                meditationSessionsList
            }
            .navigationTitle("Chill and Meditate")
            .background(AppGradients.backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                toolbarContent
            }
            .sheet(isPresented: $showAddMeditationSheet) {
                addMeditationSheet
            }
        }
    }

    // MARK: - Private Variables
    private var addMeditationSheet: some View {
        NavigationStack {
            addMeditationForm
                .navigationTitle("Add New Meditation")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { addMeditationToolbar }
        }
        .presentationDetents([.medium])
    }
    private var meditationSessionsList: some View {
        VStack {
            ForEach(meditateViewModel.meditationSessions) { session in
                meditationCard(for: session)
            }
        }
        .padding()
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(.darkBlue)
            .frame(height: 100)
            .shadow(radius: 3)
            .visualEffect { content, proxy in
                let frame = proxy.frame(in: .scrollView(axis: .vertical))
                let distance = min(0, frame.minY)

                return content
                    .hueRotation(.degrees(frame.origin.y / 10))
                    .scaleEffect(1 + distance / 700)
                    .offset(y: -distance / 1.25)
                    .brightness(-distance / 400)
                    .blur(radius: -distance / 50)
            }
    }

    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showAddMeditationSheet = true
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.white, .indigo)
                    .shadow(radius: 5, y: 3)
            })
        }
    }

    private var addMeditationForm: some View {
        Form {
            Section(header: Text("Add Meditation Session")) {
                TextField("Meditation Title", text: $newMeditationTitle)
                TextField("Description", text: $newMeditationDescription)
                TextField("Meditation link", text: $newMeditationURL)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Duration: \(Int(newMeditationDuration)) minutes")
                            .font(.headline)
                    }

                    HStack {
                        Text("0")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Slider(value: $newMeditationDuration, in: 5...60, step: 1)

                        Text("60")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }

    private var addMeditationToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    showAddMeditationSheet = false
                }
                .foregroundStyle(.red)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveNewMeditation()
                }
                .disabled(
                    newMeditationTitle.isEmpty ||
                    newMeditationDescription.isEmpty ||
                    newMeditationDuration == 5 ||
                    newMeditationURL.isEmpty
                )
            }
        }
    }

    // MARK: - Private Functions
    private func saveNewMeditation() {
        let newMeditation = MeditationModel(
            id: UUID(),
            meditationTitle: newMeditationTitle,
            meditationDescription: newMeditationDescription,
            meditationDuration: Int(newMeditationDuration),
            meditationURL: (URL(string: newMeditationURL) ?? URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"))!
            )

        meditateViewModel.addMeditation(newMeditation)
        resetFields()
        showAddMeditationSheet = false
    }

    private func resetFields() {
        newMeditationTitle = ""
        newMeditationDescription = ""
        newMeditationDuration = 5
        newMeditationURL = ""
    }

    private func cardContent(for session: MeditationModel) -> some View {
        VStack {
            HStack {
                Text(session.meditationTitle)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .bold()
                Spacer()
                Text("\(session.meditationDuration) min")
                    .foregroundStyle(.white)
                Image(systemName: "clock")
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
            Spacer()
            HStack {
                Text(session.meditationDescription)
                    .foregroundStyle(.white)
                    .font(.caption)
                    .lineLimit(2)
                Spacer()
                Link(destination: session.meditationURL) {
                    Image(systemName: "waveform.and.person.filled")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .shadow(radius: 5)
                }
            }
            .padding(.horizontal)

        }
        .padding()
    }

    private func meditationCard(for session: MeditationModel) -> some View {
        ZStack {
            cardBackground
            cardContent(for: session)
        }
    }

}

// MARK: - Previews
#Preview ("Light Mode") {
    let context = PreviewPersistenceController.preview.container.viewContext
    return MeditationView(viewContext: context)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    let context = PreviewPersistenceController.preview.container.viewContext
    return MeditationView(viewContext: context)
        .preferredColorScheme(.dark)
}

// For preview content
struct PreviewPersistenceController {
    static let preview: PreviewPersistenceController = {
        let controller = PreviewPersistenceController(inMemory: true)
        // Add any preview data setup here
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

}
