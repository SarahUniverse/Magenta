//
//  MainViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/6/25.
//

import CoreData
import Foundation

@Observable final class MainTabViewModel {
    private let viewContext: NSManagedObjectContext
    var currentUser: UserModel?

    init(viewContext: NSManagedObjectContext, userModel: UserModel) {
        self.viewContext = viewContext
        self.currentUser = userModel
        fetchUser()
    }

    func fetchUser() {

    }

}
