//
//  User.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import SwiftData

@Model
class User {
    var id: String
    var name: String
    var isLoggedIn: Bool

    init(id: String, name: String, isLoggedIn: Bool) {
        self.id = id
        self.name = name
        self.isLoggedIn = isLoggedIn
    }
}
