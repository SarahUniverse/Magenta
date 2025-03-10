//
//  QuotesSummaryViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData

final class QuotesSummaryViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

}
