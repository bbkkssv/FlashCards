//
//  AddCartView.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import SwiftUI

// AddCardView is a SHEET that lets the user create a new flashcard
// and add it to a specific deck.
struct AddCardView: View {

    // Pull the shared store from the environment so we can call addCard()
    @EnvironmentObject var store: DeckStore

    // dismiss() is a SwiftUI action that closes this sheet when called
    @Environment(\.dismiss) private var dismiss

    // The deck this new card will be added to — passed in when the sheet opens
    let deckID: UUID

    // @State = local temporary values the user types into the text fields.
    // They start empty and are thrown away when the sheet closes.
    @State private var front: String = ""  // The question / term
    @State private var back: String = ""   // The answer / definition

    var body: some View {
        // NavigationStack gives us the title bar and toolbar inside the sheet
        NavigationStack {
            Form {
                // Section for the front of the card
                Section("FRONT") {
                    // TextField binds to the 'front' @State variable —
                    // as the user types, 'front' updates in real time
                    TextField("Question / Term", text: $front)
                }

                // Section for the back of the card
                Section("BACK") {
                    TextField("Answer / Definition", text: $back)
                }
            }
            .navigationTitle("New Card")
            .toolbar {

                // Cancel button — discard changes and close the sheet
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                // Add button — validate, save the card, then close the sheet
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        // Trim whitespace so "   " doesn't count as a real word
                        let f = front.trimmingCharacters(in: .whitespacesAndNewlines)
                        let b = back.trimmingCharacters(in: .whitespacesAndNewlines)

                        // Guard = if either field is empty after trimming, do nothing
                        guard !f.isEmpty, !b.isEmpty else { return }

                        // Tell the store to create the card and save it to disk
                        store.addCard(to: deckID, front: f, back: b)

                        // Close the sheet
                        dismiss()
                    }
                    // .disabled greys out the button and prevents tapping
                    // when either text field is blank (after trimming whitespace)
                    .disabled(
                        front.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ||
                        back.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }

            }
        }
    }
}

#Preview {
    NavigationStack {
        AddCardView(deckID: UUID())
            .environmentObject(DeckStore())
    }
}
