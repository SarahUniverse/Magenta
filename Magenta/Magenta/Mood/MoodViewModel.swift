//
//  MoodViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/8/25.
//

import CoreData
import Foundation

final class MoodViewModel: ObservableObject {
    @Published var items: [String] = []
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        setupInitialData()
    }

    private func setupInitialData() {
        items = [
            "Excited",
            "Happy",
            "Calm",
            "Neutral",
            "Tired",
            "Sad",
            "Anxious",
            "Angry"
        ]
    }

}
