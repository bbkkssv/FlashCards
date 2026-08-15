//
//  Deck.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

// MARK: DATA MODELING

// Foundation gives us UUID and other core types
import Foundation

// Deck is a struct that groups a name and an array of Flashcards together
// Identifiable = SwiftUI can display a list of Decks and tell them apart by id
// Codable      = can be saved to / loaded from JSON automatically
// Equatable    = we can compare two Decks with == to see if they are the same
struct Deck: Identifiable, Codable, Equatable {

    // Every Deck gets its own unique id so SwiftUI never confuses two decks
    let id: UUID

    // The human-readable name shown in the list (e.g. "Spanish", "SwiftUI")
    var name: String

    // All the flashcards that belong to this deck
    // 'card' is an array — it can be empty [] or hold many Flashcard values
    var card: [Flashcard]

    // Custom initializer — id defaults to a new UUID() so callers only need
    // to supply a name and cards
    init(id: UUID = UUID(), name: String, card: [Flashcard]) {
        self.id = id
        self.name = name
        self.card = card
    }

}
