//
//  ArtTherapyModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/12/25.
//

import CoreData
import Foundation

struct ArtTherapyModel: Identifiable, Hashable {
    let id: UUID
    let activityDescription: String
    let activityName: String
    let therapeuticValue: String

    init(entity: ArtTherapyEntity) {
        id = entity.id ?? UUID()
        activityDescription = entity.activityDescription ?? ""
        activityName = entity.activityName ?? ""
        therapeuticValue = entity.therapeuticValue ?? ""
    }

    init(id: UUID, activityDescription: String, activityName: String, therapeuticValue: String) {
        self.id = id
        self.activityDescription = activityDescription
        self.activityName = activityName
        self.therapeuticValue = therapeuticValue
    }

}
