//
//  JournalViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/18/25.
//

import CoreData
import JournalingSuggestions
import SwiftUI

final class JournalViewModel: ObservableObject {

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
}
