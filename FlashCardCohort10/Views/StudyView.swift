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

    // Settings persisted via @AppStorage
    @AppStorage("showBackFirst") private var showBackFirst: Bool = false
    @AppStorage("shuffleCards") private var shuffleCards: Bool = true
    @AppStorage("cardsPerSession") private var cardsPerSession: Int = 10
    @AppStorage("fontSizeScale") private var fontSizeScale: Double = 1.0
    @AppStorage("themeName") private var themeName: String = "Classic"

    var body: some View {
        VStack(spacing: 16) {

            if sessionCards.isEmpty {
                Text("No cards inside this deck")
                    .foregroundStyle(.secondary)
            } else {
                Text("\(index + 1) / \(sessionCards.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ZStack {
                CardThemeHelper.cardBackground(for: themeName)
                    .frame(height: 220)

                Text(currentText)
                    .font(.system(size: CGFloat(17 * fontSizeScale), weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isFlipped.toggle()
                }
            }

            HStack(spacing: 12) {

                Button("Prev") {
                    prev()
                }
                .buttonStyle(.borderedProminent)
                .disabled(index == 0)

                Button("Flip card to \(isFlipped ? "Back" : "Front")") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isFlipped.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Next") {
                    next()
                }
                .buttonStyle(.borderedProminent)
                .disabled(index == sessionCards.count - 1)

            }
        }
        .padding()
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
