//
//  SettingsView.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import SwiftUI

struct SettingsView: View {

    // Existing settings
    @AppStorage("showBackFirst") private var showBackFirst: Bool = false
    @AppStorage("shuffleCards") private var shuffleCards: Bool = true
    @AppStorage("cardsPerSession") private var cardsPerSession: Int = 10

    // New settings
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("fontSizeScale") private var fontSizeScale: Double = 1.0
    @AppStorage("accentColorName") private var accentColorName: String = "Blue"
    @AppStorage("themeName") private var themeName: String = "Classic"

    var body: some View {
        Form {
            Section("Study") {
                Toggle("Shuffle cards", isOn: $shuffleCards)
                Toggle("Show back first", isOn: $showBackFirst)
                Stepper("Cards per session: \(cardsPerSession)",
                    value: $cardsPerSession,
                    in: 1...50
                )
            }

            Section("Appearance") {
                Toggle("Dark Mode", isOn: $isDarkMode)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Font Size: \(fontSizeScale, specifier: "%.1f")×")
                    Slider(value: $fontSizeScale, in: 0.8...1.5, step: 0.1)
                }
                .padding(.vertical, 4)

                Picker("Accent Color", selection: $accentColorName) {
                    ForEach(CardThemeHelper.colorNames, id: \.self) { name in
                        HStack {
                            Circle()
                                .fill(CardThemeHelper.accentColor(for: name))
                                .frame(width: 14, height: 14)
                            Text(name)
                        }
                        .tag(name)
                    }
                }

                Picker("Card Theme", selection: $themeName) {
                    ForEach(CardThemeHelper.themeNames, id: \.self) { name in
                        Text(name).tag(name)
                    }
                }
            }

            Section("About") {
                Text("Settings are being persisted using UserDefaults via @AppStorage")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
    }

}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
