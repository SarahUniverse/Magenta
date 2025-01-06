//
//  MagentaApp.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import CoreData
import GoogleSignIn
import SwiftUI

@main
struct MagentaApp: App {
// Create an observable instance of the Core Data stack.
    @StateObject private var coreDataStack = CoreDataStack.shared

    var body: some Scene {
        let users: [UserModel] = []
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                // Inject the persistent container's managed object context into the environment
                .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
        }
    }
}
