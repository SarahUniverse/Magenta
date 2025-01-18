//
//  JournalModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/18/25.
//

import CoreData
import Foundation

struct JournalModel: Identifiable, Hashable {
    let id: UUID
    let journalEntryTitle: String
    let journalEntryDate: Date
    let journalEntryContent: String

    init(entity: JournalEntity) {
        id = entity.id ?? UUID()
        journalEntryTitle = entity.title ?? ""
        journalEntryDate = entity.date ?? Date()
        journalEntryContent = entity.content ?? ""
    }

    init(id: UUID, title: String, date: Date, content: String) {
        self.id = id
        self.journalEntryTitle = title
        self.journalEntryDate = date
        self.journalEntryContent = content
    }

}
