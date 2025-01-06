//
//  UserEntity+CoreDataProperties.swift
//  Magenta
//
//  Created by Sarah Clark on 1/6/25.
//
//

import CoreData
import Foundation

extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var username: String?

}
