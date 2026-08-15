//
//  DeckListView.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import SwiftUI
import Combine

struct DeckListView: View {

    @EnvironmentObject var store: DeckStore
    @State private var showingAddDeck = false

    var body: some View {
        List {
            Section("Decks") {
                ForEach(store.decks) { deck in
                    NavigationLink {
                        DetailView(deckID: deck.id)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(deck.name)
                            Text("\(deck.card.count) cards")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { offsets in
                    store.deleteDeck(at: offsets)
                }
            }
        }
        .navigationTitle("Flashcards")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddDeck = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
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
