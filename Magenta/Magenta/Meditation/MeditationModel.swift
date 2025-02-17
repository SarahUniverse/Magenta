//
//  MeditationModel.swift
//  Magenta
//
//  Created by Sarah Clark on 2/16/25.
//

import CoreData
import Foundation

struct MeditationModel: Identifiable {
    let id: UUID
    let meditationTitle: String
    let meditationDescription: String
    let meditationDuration: Int
    let meditationURL: URL

    init(entity: MeditationEntity) {
        id = entity.id ?? UUID()
        meditationTitle = entity.meditationTitle ?? ""
        meditationDescription = entity.meditationDescription ?? ""
        meditationDuration = Int(entity.meditationDuration)
        meditationURL = entity.meditationURL ?? URL(string: "")!
    }

    init(id: UUID, meditationTitle: String, meditationDescription: String, meditationDuration: Int, meditationURL: URL) {
        self.id = id
        self.meditationTitle = meditationTitle
        self.meditationDescription = meditationDescription
        self.meditationDuration = meditationDuration
        self.meditationURL = meditationURL
    }

}
