//
//  MainViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/6/25.
//

import CoreData
import Foundation

final class MainTabViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext
    @Published var currentUser: UserModel?

    init(viewContext: NSManagedObjectContext, userModel: UserModel) {
        self.viewContext = viewContext
        self.currentUser = userModel
        fetchUser()
    }

    func fetchUser() {

    }

}
