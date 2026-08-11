//
//  SettingsView.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import SwiftUI

struct SettingsView: View {

    // Settings for our app
    @AppStorage("showBackFirst") private var showBackFirst: Bool = false
    @AppStorage("shuffleCards") private var shuffleCards: Bool = true
    @AppStorage("cardsPerSession") private var cardsPerSession: Int = 10

    var body: some View {

        Form {
            Section("Study") {
                Toggle("Shuffle cards", isOn: $shuffleCards)
                Toggle("Show back first", isOn: $showBackFirst)
                Stepper("Card per session: \(cardsPerSession)",
                    value: $cardsPerSession,
                    in: 1...50
                )
            }

            Section("About") {
                Text("Settings are being persisted using UserDefaults via @AppStorage")
            }
        }.navigationTitle("Settings")
    }

}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
