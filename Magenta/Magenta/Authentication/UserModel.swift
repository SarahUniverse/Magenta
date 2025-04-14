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
    let isUserSignedUp: Bool
    let isUserLoggedIn: Bool

    init(entity: UserEntity) {
        self.id = entity.id ?? UUID()
        username = entity.username ?? ""
        email = entity.email ?? ""
        isUserSignedUp = entity.isUserSignedUp
        isUserLoggedIn = entity.isUserLoggedIn
    }

    init(id: UUID, username: String, email: String, isUserSignedUp: Bool, isUserLoggedIn: Bool) {
        self.id = id
        self.username = username
        self.email = email
        self.isUserSignedUp = isUserSignedUp
        self.isUserLoggedIn = isUserLoggedIn
    }

}

extension UserModel {
    static func userModelDataSample(viewContext: NSManagedObjectContext) -> UserModel {
        let sampleUserEntity = UserEntity(context: viewContext)
        sampleUserEntity.username = "Sarah"
        sampleUserEntity.email = "sarah@example.com"
        sampleUserEntity.isUserSignedUp = true
        sampleUserEntity.isUserLoggedIn = true

        return UserModel(entity: sampleUserEntity)
    }
}
