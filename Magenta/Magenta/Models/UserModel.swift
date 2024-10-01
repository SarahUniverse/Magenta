//
//  User.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftData

@Model
class UserModel {
    var id: String
    var name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
