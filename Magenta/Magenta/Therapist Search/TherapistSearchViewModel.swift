//
//  TherapistSearchViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData

final class TherapistSearchViewModel: ObservableObject {
    @Published var therapists: [TherapistModel] = []
}
