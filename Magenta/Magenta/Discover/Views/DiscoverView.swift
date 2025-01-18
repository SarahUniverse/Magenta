//
//  DiscoverView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/13/25.
//

import CoreData
import SwiftUI
import UIKit

struct DiscoverView: View {
    @StateObject var discoverViewModel: DiscoverViewModel
    @State private var searchText = ""
    @State private var isListening = false
    @State private var showError = false
    @State private var errorMessage = ""
    @Environment(\.colorScheme) private var colorScheme

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

    // MARK: - Private Variables
    private var mainContentView: some View {
        ZStack {
            backgroundGradient
                .edgesIgnoringSafeArea(.all)

            VStack {
                searchSection
                itemListSection
            }
        }
        .navigationTitle("Discover")
        .navigationBarItems(trailing: signOutButton)
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $discoverViewModel.shouldShowLoginView) {
            LoginView(viewContext: discoverViewModel.viewContext)
        }
    }

    private var searchSection: some View {
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
    }

    private var itemListSection: some View {
        List {
            ForEach(discoverViewModel.filteredItems(searchText: searchText)) { item in
                NavigationLink(destination: discoverViewModel.destinationView(for: item)) {
                    itemRowContent(item)
                }
                .padding(.vertical, 10)
            }
            .onChange(of: colorScheme) {
                discoverViewModel.updateColorScheme($1)
            }
        }
    }

    private var signOutButton: some View {
        Button(action: {
            discoverViewModel.signOut()
        }, label: {
            Text("Sign Out")
                .padding(8)
                .cornerRadius(20)
                .foregroundStyle(discoverViewModel.colors.textColor)
        })
    }

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        _discoverViewModel = StateObject(wrappedValue: DiscoverViewModel(viewContext: viewContext, colorScheme: colorScheme))
    }

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            mainContentView
        }
    }

    // MARK: - Private Functions
    private func itemRowContent(_ item: DiscoverItemModel) -> some View {
        HStack {
            item.icon
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(.trailing, 10)
                .foregroundStyle(
                    LinearGradient(
                        colors: item.iconColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text(item.title)
                .foregroundStyle(discoverViewModel.colors.textColor)
        }
    }

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
