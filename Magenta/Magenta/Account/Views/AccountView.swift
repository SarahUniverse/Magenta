//
//  AccountView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import SwiftUI

struct AccountView: View {
    @StateObject private var accountViewModel: AccountViewModel
    @Environment(\.colorScheme) private var colorScheme

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        _accountViewModel = StateObject(wrappedValue: AccountViewModel(viewContext: viewContext, colorScheme: colorScheme))
    }

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.darkPurple,
            Color.darkBlue,
            Color.black,
            Color.black,
            Color.black,
            Color.black
        ]),
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )

    // MARK: - Main View code
    var body: some View {
        NavigationStack {
            List {
                Text("Hello, World!")
            }
            .padding(.top, 20)
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .fullScreenCover(isPresented: $accountViewModel.shouldShowLoginView) {
                LoginView(viewContext: accountViewModel.viewContext)
            }
            .navigationTitle("Account")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        accountViewModel.signOut()
                    }, label: {
                        Text("Sign Out")
                            .padding(8)
                            .foregroundStyle(accountViewModel.colors.textColor)
                    })
            )
            .onChange(of: colorScheme) {
                accountViewModel.updateColorScheme($1)
            }
        }
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

    return AccountView(viewContext: persistentContainer.viewContext, colorScheme: .light)
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

    return AccountView(viewContext: persistentContainer.viewContext, colorScheme: .dark)
        .preferredColorScheme(.dark)
}
