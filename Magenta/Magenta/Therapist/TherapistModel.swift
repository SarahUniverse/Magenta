//
//  TherapistModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

import CoreData
import Foundation

struct TherapistModel: Identifiable {
    var id: UUID
    var name: String
    var email: String
    var phone: String
    var location: String
    var specialty: String
    var rating: Double
    var distance: Double

    init(entity: TherapistEntity) {
        id = entity.id ?? UUID()
        name = entity.name ?? ""
        email = entity.email ?? ""
        phone = entity.phone ?? ""
        location = entity.location ?? ""
        specialty = entity.specialty ?? ""
        rating = entity.rating
        distance = entity.distance
    }

    init(id: UUID, name: String, email: String, phone: String, location: String, specialty: String, rating: Double, distance: Double) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.location = location
        self.specialty = specialty
        self.rating = rating
        self.distance = distance
    }

}
