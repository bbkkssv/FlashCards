//
//  DeckStore.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import Foundation
import Combine
import SwiftUI

// MARK: - DeckStore (ViewModel)

// @MainActor guarantees that every property change and function call on this class
// happens on the MAIN thread — required because SwiftUI updates the UI on the main thread.
@MainActor

// ObservableObject = any SwiftUI view that holds a reference to this class
// will automatically re-render when a @Published property changes.
class DeckStore: ObservableObject {

    // @Published = SwiftUI watches this property.
    // Whenever 'decks' changes, all views using DeckStore will refresh.
    // didSet runs a block of code EVERY time 'decks' is assigned a new value.
    // We use it to auto-save — any CRUD operation that changes 'decks'
    // automatically triggers save(), keeping the file on disk up to date.
    @Published var decks: [Deck] = [] {
        didSet { save() }
    }

    // Our FileStore service — responsible for reading/writing decks.json
    // 'private' means only DeckStore can use it directly
    private let store = FileStore(fileName: "decks.json")

    // MARK: - Init

    // init() runs once when DeckStore is created (at app launch).
    // 1. Try to load saved decks from disk
    // 2. If the file doesn't exist yet (first launch), fall back to sample data
    init() {
        load()
        if decks.isEmpty {
            decks = sampleDecks
        }
    }

    // MARK: - Persistence

    // load() asks FileStore to read decks.json and decode it into [Deck].
    // If anything goes wrong (file missing, corrupt JSON, etc.) we catch the
    // error and set decks to an empty array so the app doesn't crash.
    private func load() {
        do {
            decks = try store.load([Deck].self)
        } catch {
            // First launch: file doesn't exist yet — that's fine, start empty
            decks = []
        }
    }

    // save() asks FileStore to encode our current decks array and write it to disk.
    // Called automatically from didSet every time 'decks' changes.
    private func save() {
        do {
            try store.save(decks)
        } catch {
            // Print the error so we can see it in the Xcode console
            print("Could not save our decks... \(error.localizedDescription)")
        }
    }

    // MARK: - Deck CRUD Operations

    // READ — find a single Deck by its UUID.
    // Returns Deck? (optional) because the deck might not exist.
    // firstIndex(where:) scans the array and returns the matching deck or nil.
    func deck(for deckID: UUID) -> Deck? {
        decks.first(where: { $0.id == deckID })
    }

    // CREATE — make a new Deck with an empty card array and add it to the list.
    // Appending to 'decks' triggers didSet -> save() automatically.
    func addDeck(name: String) {
        let newDeck: Deck = Deck(name: name, card: [])
        decks.append(newDeck)
    }

    // DELETE — remove one or more Decks at the given positions.
    // IndexSet is a set of array positions — SwiftUI's List passes this
    // from its onDelete handler when the user swipes to delete.
    func deleteDeck(at offsets: IndexSet) {
        decks.remove(atOffsets: offsets)
    }

    // MARK: - Flashcard CRUD Operations

    // CREATE — add a new Flashcard to a specific Deck.
    // We find the deck by searching for its index in the array,
    // then mutate that element directly with decks[i].card.append(...)
    func addCard(to deckID: UUID, front: String, back: String) {

        // firstIndex(where:) returns the position of the matching deck in the array
        // If no deck matches, 'guard let' exits the function early (return)
        guard let i = decks.firstIndex(where: {
            $0.id == deckID
        }) else { return }

        // Append a new Flashcard to that deck's card array
        // This mutates 'decks', which triggers didSet -> save()
        decks[i].card.append(Flashcard(front: front, back: back))
    }

    // DELETE — remove one or more Flashcards from a specific Deck.
    // Same pattern as addCard: find the deck index, then mutate its card array.
    func deleteCard(in deckID: UUID, at offsets: IndexSet) {
        guard let i = decks.firstIndex(where: {
            $0.id == deckID
        }) else { return }
        decks[i].card.remove(atOffsets: offsets)
    }

    // MARK: - Sample Data

    // sampleDecks is used on first launch when there is no saved file yet.
    // It gives the user something to see and study right away.
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
