//
//  UserModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/6/25.
//

import CoreData
import Foundation

struct UserModel: Identifiable {
    let id: UUID
    let username: String
    let email: String

    init(entity: UserEntity) {
        self.id = entity.id ?? UUID()
        username = entity.username ?? ""
        email = entity.email ?? ""
    }

    init(id: UUID, username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
    }

}
