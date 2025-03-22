//
//  EditProfileViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData
import UIKit

@Observable class EditProfileViewModel {
    var profileImage: UIImage?
    var firstName = ""
    var lastName = ""
    var displayName = ""
    var birthday = Date()
    var email = ""
    var phone = ""
    var bio = ""

    func saveProfile() {
        // Implement save logic
    }
}
