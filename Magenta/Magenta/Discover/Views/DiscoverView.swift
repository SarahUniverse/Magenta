//
//  DiscoverView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/13/25.
//

import CoreData
import SwiftUI

struct DiscoverView: View {
    @StateObject var discoverViewModel: DiscoverViewModel
    @State private var searchText = ""
    @State private var isListening = false
    @State private var showError = false
    @State private var errorMessage = ""
    @Environment(\.colorScheme) private var colorScheme

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        _discoverViewModel = StateObject(wrappedValue: DiscoverViewModel(viewContext: viewContext, colorScheme: colorScheme))
    }

    var body: some View {
        NavigationStack {
            // TODO: Make SignOut button it's own view
            VStack {
                SearchView(
                    text: $searchText,
                    isListening: $isListening,
                    startListening: {
                        startSpeechRecognition()
                    },
                    stopListening: {
                        discoverViewModel.stopSpeechRecognition()
                    }
                )

                List {
                    // Filtered content based on search text
                    ForEach(discoverViewModel.filteredItems(searchText: searchText)) { item in
                        Text(item.title)
                            .foregroundStyle(discoverViewModel.colors.textColor)
                    }
                }
            }
            .navigationTitle("Discover")
            .alert("Error", isPresented: $showError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
        .onAppear {
            discoverViewModel.updateColorScheme(colorScheme)
        }
    }

    // MARK: - Private Functions
    private func startSpeechRecognition() {
        do {
            try discoverViewModel.startSpeechRecognition { recognitionText in
                searchText = recognitionText
            }
        } catch {
            showError = true
            errorMessage = error.localizedDescription
            isListening = false
        }
    }

    private func stopSpeechRecognition() {
        discoverViewModel.stopSpeechRecognition()
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    return DiscoverView(viewContext: persistentContainer.viewContext, colorScheme: .light)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    return DiscoverView(viewContext: persistentContainer.viewContext, colorScheme: .dark)
        .preferredColorScheme(.dark)
}
