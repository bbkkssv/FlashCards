//
//  StudyView.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import SwiftUI

struct StudyView: View {

    var deck: Deck

    @State private var index: Int = 0
    @State private var isFlipped: Bool = false
    @State private var sessionCards: [Flashcard] = []

    // Settings for our app
    @AppStorage("showBackFirst") private var showBackFirst: Bool = false
    @AppStorage("shuffleCards") private var shuffleCards: Bool = true
    @AppStorage("cardsPerSession") private var cardsPerSession: Int = 10

    var body: some View {
        VStack(spacing: 12) {

            if sessionCards.isEmpty {
                Text("No cards inside this deck")
            } else {
                Text("\(index+1) / \(sessionCards.count)")
            }

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.thinMaterial)
                    .frame(height: 220)

                Text(currentText)
                    .padding()

            }.onTapGesture {
                isFlipped.toggle()
            }

            HStack(spacing: 12) {

                Button("Prev") {
                    prev()
                }
                .buttonStyle(.borderedProminent)
                .disabled(index == 0)

                Button("Flip card to \(isFlipped ? "Back" : "Front")") {
                    isFlipped.toggle()
                }
                .buttonStyle(.borderedProminent)

                Button("Next") {
                    next()
                }
                .buttonStyle(.borderedProminent)
                .disabled(index == sessionCards.count - 1)

            }
        }
        .navigationTitle(deck.name)
        .onAppear {
            startSession()
        }
    }

    private var currentText: String {

        guard !sessionCards.isEmpty else { return "EMPTY CARD" }
        let card = sessionCards[index]
        let showingFront = showBackFirst ? isFlipped : !isFlipped
        return showingFront ? card.front : card.back
    }

    private func startSession() {
        var cards = deck.card

        if shuffleCards { cards.shuffle() }
        let limit = min(cardsPerSession, cards.count)
        sessionCards = Array(cards.prefix(limit))
        index = 0
        isFlipped = false
    }

    private func prev() {
        if index > 0 {
            index -= 1
            isFlipped = false
        }
    }

    private func next() {
        if index < sessionCards.count - 1 {
            index += 1
            isFlipped = false
        }
    }

}

#Preview {
    NavigationStack {
        StudyView(deck: Deck(name: "SwiftUI", card: [
            Flashcard(front: "var", back: "can change value"),
            Flashcard(front: "let", back: "the value is contant")
        ]))
    }
}
