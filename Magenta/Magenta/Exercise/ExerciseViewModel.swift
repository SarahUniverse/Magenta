//
//  ExerciseViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/7/25.
//

import Combine
import CoreData
import SwiftUI

@Observable final class ExerciseViewModel {
    var stepCount: Int = 0
    // private var healthKitManager = HealthKitManager()
    private var cancellables = Set<AnyCancellable>()
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

}
