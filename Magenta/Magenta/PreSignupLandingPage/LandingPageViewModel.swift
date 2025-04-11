//
//  LandingPageViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 4/11/25.
//

import CoreData
import SwiftUI

@Observable final class LandingPageViewModel {
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

}
