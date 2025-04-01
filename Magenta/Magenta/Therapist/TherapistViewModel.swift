//
//  TherapistViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 4/1/25.
//

import CoreData
import SwiftUI

@Observable
final class TherapistViewModel {
    var therapists: [TherapistModel] = []
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

}
