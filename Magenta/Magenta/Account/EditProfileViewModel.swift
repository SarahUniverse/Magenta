//
//  EditProfileViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData
import UIKit

class EditProfileViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var displayName = ""
    @Published var birthday = Date()
    @Published var email = ""
    @Published var phone = ""
    @Published var bio = ""

    func saveProfile() {
        // Implement save logic
    }
}
