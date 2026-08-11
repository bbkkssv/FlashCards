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

    var body: some View {
        List {
            Section("Decks") {
                ForEach(store.decks) { deck in
                    NavigationLink {
                        StudyView(deck: deck)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(deck.name)
                            Text("\(deck.card.count)")
                        }
                    }
                }
            }
        }
        .navigationTitle("Flashcards")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeckListView().environmentObject(DeckStore())
        
    }
    
}
