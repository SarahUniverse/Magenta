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
    @StateObject private var coreDataStack = CoreDataStack.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewContext: coreDataStack.persistentContainer.viewContext)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
        }
    }
}
