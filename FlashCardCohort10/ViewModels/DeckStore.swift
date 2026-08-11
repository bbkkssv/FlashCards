//
//  DeckStore.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import Foundation
import Combine

// This is my ViewModel
class DeckStore: ObservableObject {

    @Published var decks: [Deck] = [

        Deck(name: "SwiftUI", card: [
            Flashcard(front: "var", back: "can change value"),
            Flashcard(front: "let", back: "the value is contant"),
        ]),
        Deck(name: "Spanish", card: [
            Flashcard(front: "Hello", back: "Hola"),
            Flashcard(front: "Goodbye", back: "Adios")
        ])

    ]

}
