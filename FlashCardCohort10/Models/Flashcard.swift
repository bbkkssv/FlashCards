//
//  Flashcard.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

// Foundation gives us access to UUID, which creates unique IDs
import Foundation

// Flashcard is a struct (value type) that represents one card in a deck
// Identifiable = SwiftUI can loop over a list of Flashcards and tell them apart
// Codable     = can be converted TO json (Encodable) and FROM json (Decodable)
// Equatable   = we can compare two Flashcards with == to check if they are the same
struct Flashcard: Identifiable, Codable, Equatable {

    // id is a unique identifier — every Flashcard gets its own UUID so SwiftUI
    // can track it in a List even if the front/back text is the same
    let id: UUID

    // front = the question or term shown first
    var front: String

    // back = the answer or definition revealed after flipping
    var back: String

    // Custom initializer so we can create a Flashcard with just front and back.
    // id has a default value of UUID() so callers don't need to supply one —
    // Swift generates a fresh unique ID automatically every time.
    init(id: UUID = UUID(), front: String, back: String) {
        self.id = id
        self.front = front
        self.back = back
    }
}
