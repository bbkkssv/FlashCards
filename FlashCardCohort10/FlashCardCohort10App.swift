//
//  FlashCardCohort10App.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import SwiftUI

// @main tells Swift "this is where the app starts"
@main
struct FlashcardCohort10App: App {

    // @StateObject creates ONE instance of DeckStore for the entire app lifetime.
    // SwiftUI owns it here at the top level — it won't be destroyed while the app runs.
    @StateObject var store = DeckStore()

    // @AppStorage reads/writes a value in UserDefaults automatically.
    // "isDarkMode" is the UserDefaults key — same key used in SettingsView.
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    // Same pattern — reads the saved accent color name from UserDefaults
    @AppStorage("accentColorName") private var accentColorName: String = "Blue"

    // 'body' defines the window/scene structure of the app
    var body: some Scene {

        // WindowGroup = the main window of the app (required for iOS apps)
        WindowGroup {

            // NavigationStack enables push navigation (drill-down screens)
            // DeckListView is the first screen the user sees
            NavigationStack {
                DeckListView()
            }

            // Pass the DeckStore down to every child view via the environment.
            // Any view that declares @EnvironmentObject var store: DeckStore
            // will receive this same shared instance.
            .environmentObject(store)

            // Switch the entire app between light and dark mode based on the
            // saved setting — changes instantly when the user toggles it in Settings
            .preferredColorScheme(isDarkMode ? .dark : .light)

            // Set the app-wide tint (button colors, selected states) based on
            // the saved accent color — resolved by CardThemeHelper
            .tint(CardThemeHelper.accentColor(for: accentColorName))
        }
    }
}
