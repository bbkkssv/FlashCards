//
//  DeckStore.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import Foundation
import Combine
import SwiftUI

// This is my ViewModel
@MainActor
class DeckStore: ObservableObject {

    @Published var decks: [Deck] = [] {
        didSet {}
    }

    private let store = FileStore(fileName: "decks.json")

    init() {
        load()
        if decks.isEmpty {
            decks = sampleDecks
        }
    }

    private func load() {
        do {
            decks = try store.load([Deck].self)
        } catch {
            decks = []
        }
    }

    private func save() {
        do {
            try store.save(decks)
        } catch {
            print("Could not save our decks... \(error.localizedDescription)")
        }
    }


    //MARK: DECK CRUD OPERATIONS
    //Challenge #1
    // create a function called deck, this functions will receive the deckID and it will return
    // the DECK object if it matches one of the decks that we have inside our decks variables
    // make it optional
    func deck(for deckID: UUID) -> Deck? {
        decks.first(where: { $0.id == deckID })
    }

    //Challenge #2
    // create a function named addDeck, this function receives a deck name, creates a new deck with that name, and add an empty array of
    // cards, then inserts the new deck to our existing collection of decks
    func addDeck(name: String) {
        let newDeck: Deck = Deck(name: name, card: [])
        decks.append(newDeck)
    }

    func deleteDeck(at offsets: IndexSet) {
        decks.remove(atOffsets: offsets)
    }


    //MARK: FLASHCARD CRUD OPERATIONS
    func addCard(to deckID: UUID, front: String, back: String) {

        guard let i = decks.firstIndex(where: {
            $0.id == deckID
        }) else { return }

        decks[i].card.append(Flashcard(front: front, back: back))
    }

    func deleteCard(in deckID: UUID, at offsets: IndexSet) {
        guard let i = decks.firstIndex(where: {
            $0.id == deckID
        }) else { return }
        decks[i].card.remove(atOffsets: offsets)
    }


    @Published var sampleDecks: [Deck] = [

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
