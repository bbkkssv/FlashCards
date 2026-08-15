//
//  AddCartView.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import SwiftUI

struct AddCardView: View {

    @EnvironmentObject var store: DeckStore
    @Environment(\.dismiss) private var dismiss

    let deckID: UUID

    @State private var front: String = ""
    @State private var back: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("FRONT") {
                    TextField("Question / Term", text: $front)
                }
                Section("BACK") {
                    TextField("Answer / Definition", text: $back)
                }
            }
            .navigationTitle("New Card")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        let f = front.trimmingCharacters(in: .whitespacesAndNewlines)
                        let b = back.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !f.isEmpty, !b.isEmpty else { return }
                        store.addCard(to: deckID, front: f, back: b)
                        dismiss()
                    }
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
