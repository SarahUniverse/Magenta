//
//  BlockedUsersModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import Foundation

struct BlockedUserModel: Identifiable {
    let id: String
    let name: String
    let avatarURL: URL?
    let blockedDate: Date

    init(id: String, name: String, avatarURL: URL? = nil, blockedDate: Date) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
        self.blockedDate = blockedDate
    }

}
