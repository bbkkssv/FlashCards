//
//  FlashCardModel.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

// MARK: DATA MODELING
import Foundation

struct Deck: Identifiable {

    let id: UUID = UUID()
    var name: String
    var card: [Flashcard]
}

struct Flashcard: Identifiable {

    let id: UUID = UUID()
    var front: String
    var back: String
}
