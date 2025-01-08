//
//  MoodViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/8/25.
//

import Foundation

final class MoodViewModel: ObservableObject {
    @Published var items: [String] = []

    init() {
        setupInitialData()
    }

    private func setupInitialData() {
        items = [
            "Happy",
            "Sad",
            "Angry",
            "Confused",
            "Relaxed",
            "Happy",
            "Sad",
            "Angry",
        ]
    }

}
