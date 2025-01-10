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

    init() {
        self.id = UUID()
        self.username = ""
        self.email = ""
    }

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

extension UserModel {
    static func userModelDataSample(viewContext: NSManagedObjectContext) -> UserModel {
        let sampleUserEntity = UserEntity(context: viewContext)
        sampleUserEntity.username = "Sarah"
        sampleUserEntity.email = "sarah@example.com"

        return UserModel(entity: sampleUserEntity)
    }
}
