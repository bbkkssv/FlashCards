//
//  DetailView.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/13/26.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var store: DeckStore

    let deckID: UUID

    @State private var showingAddCard = false

    var body: some View {
        let deck = store.deck(for: deckID)

        List {
            if let deck {
                Section("Cards") {
                    if deck.card.isEmpty {
                        Text("No cards yet. Tap + to add one.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(deck.card) { card in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(card.front).font(.headline)
                                Text(card.back)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { offsets in
                            store.deleteCard(in: deckID, at: offsets)
                        }
                    }
                }

                Section {
                    NavigationLink {
                        StudyView(deck: deck)
                    } label: {
                        Label("Study this deck", systemImage: "play.circle.fill")
                    }
                }
            } else {
                Text("Deck not found.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(deck?.name ?? "Deck")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddCard = true
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(deck == nil)
            }
        }
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
