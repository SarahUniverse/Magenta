//
//  MeditateViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/7/25.
//

import Combine


final class MeditateViewModel: ObservableObject {
    @Published var meditationSessions: [String] = []

    init() {
        fetchMeditationSessions()
    }

    func fetchMeditationSessions() {
        // Simulate fetching meditation sessions
        meditationSessions = [
            "Session 1: 10 minutes",
            "Session 2: 15 minutes",
            "Session 3: 20 minutes"
        ]
    }
}
