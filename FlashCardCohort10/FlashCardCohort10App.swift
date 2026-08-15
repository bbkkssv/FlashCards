//
//  FlashCardCohort10App.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import SwiftUI

@main
struct FlashcardCohort10App: App {

    @StateObject var store = DeckStore()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("accentColorName") private var accentColorName: String = "Blue"

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DeckListView()
            }
            .environmentObject(store)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .tint(CardThemeHelper.accentColor(for: accentColorName))
        }
    }
}
