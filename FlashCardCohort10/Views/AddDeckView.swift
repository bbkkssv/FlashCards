//
//  AddDeckView.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import SwiftUI

// AddDeckView is a SHEET that lets the user create a brand-new deck
// by typing a name for it.
struct AddDeckView: View {

    // Pull the shared store from the environment so we can call addDeck()
    @EnvironmentObject var store: DeckStore

    // dismiss() closes this sheet when called
    @Environment(\.dismiss) private var dismiss

    // The name the user types — starts empty, used to create the deck
    @State private var name: String = ""

    var body: some View {
        // NavigationStack gives us the title bar and toolbar inside the sheet
        NavigationStack {
            Form {
                Section("DECK NAME") {
                    // TextField binds to 'name' — updates in real time as the user types
                    TextField("e.g. Enter name", text: $name)
                }
            }
            .navigationTitle("New Deck")
            .toolbar {

                // Cancel — throw away the typed name and close the sheet
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                // Add — validate the name, create the deck, then close the sheet
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        // Trim leading/trailing whitespace before saving
                        let n = name.trimmingCharacters(in: .whitespacesAndNewlines)

                        // If the name is empty after trimming, stop here
                        guard !n.isEmpty else { return }

                        // Tell the store to create a new deck with an empty card array.
                        // DeckStore.addDeck() also triggers save() via didSet.
                        store.addDeck(name: n)

                        // Close the sheet — the new deck will appear in DeckListView
                        dismiss()
                    }
                    // Grey out and disable the Add button while the name field is blank
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

            }
        }
    }
}

#Preview {
    NavigationStack {
        AddDeckView().environmentObject(DeckStore())
    }
}
