//
//  DeckListView.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import SwiftUI
import Combine

// DeckListView is the HOME SCREEN — it shows all the user's decks in a list
struct DeckListView: View {

    // @EnvironmentObject pulls the shared DeckStore from the environment.
    // The App file injected it with .environmentObject(store).
    // Any time store.decks changes, this view re-renders automatically.
    @EnvironmentObject var store: DeckStore

    // @State controls whether the "Add Deck" sheet is visible.
    // true = sheet is showing, false = sheet is hidden
    @State private var showingAddDeck = false

    var body: some View {
        List {
            Section("Decks") {

                // ForEach loops over every Deck in store.decks and creates one row per deck
                ForEach(store.decks) { deck in

                    // NavigationLink = tapping this row pushes DetailView onto the stack
                    NavigationLink {
                        // DetailView receives the deck's ID so it can look up the deck
                        // from the store (keeps data in one place)
                        DetailView(deckID: deck.id)
                    } label: {
                        // The visible row content
                        VStack(alignment: .leading) {
                            Text(deck.name)           // e.g. "Spanish"
                            Text("\(deck.card.count) cards") // e.g. "4 cards"
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                // onDelete gives swipe-to-delete behaviour.
                // SwiftUI passes an IndexSet of the rows the user wants to remove.
                .onDelete { offsets in
                    store.deleteDeck(at: offsets)
                }
            }
        }

        .navigationTitle("Flashcards")

        .toolbar {

            // EditButton (leading/left) toggles the list into edit mode,
            // showing the red delete circles on each row
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }

            // Plus button (trailing/right) opens AddDeckView as a sheet
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddDeck = true
                } label: {
                    Image(systemName: "plus")
                }
            }

            // Gear button (trailing/right) navigates to SettingsView
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }

        // .sheet presents AddDeckView as a slide-up card.
        // It is shown when showingAddDeck == true and dismissed automatically
        // when the user taps Cancel or Add inside AddDeckView.
        .sheet(isPresented: $showingAddDeck) {
            AddDeckView()
        }
    }
}

#Preview {
    NavigationStack {
        DeckListView().environmentObject(DeckStore())
    }
}
