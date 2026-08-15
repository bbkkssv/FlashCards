//
//  DetailView.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/13/26.
//

import SwiftUI

// DetailView shows all the cards inside ONE specific deck.
// It also lets the user add/delete cards and navigate to StudyView.
struct DetailView: View {

    // Shared data store — injected from the environment
    @EnvironmentObject var store: DeckStore

    // The UUID of the deck we are displaying.
    // We store the ID (not the Deck itself) so we always read the
    // latest version from the store instead of a stale copy.
    let deckID: UUID

    // Controls whether the "Add Card" sheet is showing
    @State private var showingAddCard = false

    var body: some View {

        // Look up the deck every time the view redraws.
        // Because 'store' is @EnvironmentObject, any change to store.decks
        // causes the view to redraw, which re-runs this line with fresh data.
        let deck = store.deck(for: deckID)

        List {

            // Only show content if the deck was found
            if let deck {

                // MARK: Cards section
                Section("Cards") {

                    if deck.card.isEmpty {
                        // Empty state — helpful message when there are no cards yet
                        Text("No cards yet. Tap + to add one.")
                            .foregroundStyle(.secondary)
                    } else {
                        // Loop over every Flashcard in the deck
                        ForEach(deck.card) { card in
                            VStack(alignment: .leading, spacing: 6) {
                                // Front of the card = the question/term
                                Text(card.front).font(.headline)
                                // Back of the card = the answer/definition
                                Text(card.back)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        // onDelete — swipe a card row left to delete it
                        .onDelete { offsets in
                            store.deleteCard(in: deckID, at: offsets)
                        }
                    }
                }

                // MARK: Study section
                Section {
                    // NavigationLink pushes StudyView — passes the full Deck object
                    // because StudyView needs it to build the session
                    NavigationLink {
                        StudyView(deck: deck)
                    } label: {
                        Label("Study this deck", systemImage: "play.circle.fill")
                    }
                }

            } else {
                // Fallback — deck ID not found in the store (shouldn't normally happen)
                Text("Deck not found.")
                    .foregroundStyle(.secondary)
            }
        }

        // Use the deck's name as the nav bar title, fall back to "Deck" if nil
        .navigationTitle(deck?.name ?? "Deck")

        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddCard = true
                } label: {
                    Image(systemName: "plus")
                }
                // Disable the + button if the deck no longer exists
                .disabled(deck == nil)
            }
        }

        // Sheet presents AddCardView — passes the deckID so the new card
        // is added to the correct deck in the store
        .sheet(isPresented: $showingAddCard) {
            AddCardView(deckID: deckID)
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(deckID: UUID()).environmentObject(DeckStore())
    }
}
