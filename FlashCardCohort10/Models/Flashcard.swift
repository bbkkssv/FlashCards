//
//  Flashcard.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import Foundation

struct Flashcard: Identifiable,Codable, Equatable {

    // Values that i need
    let id: UUID
    var front: String
    var back: String

    //init function assigns a value to the list above
    init(id: UUID = UUID(), front: String, back: String) {
        self.id = id
        self.front = front
        self.back = back
    }
}
