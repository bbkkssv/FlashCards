//
//  CardThemeHelper.swift
//  FlashCardCohort10
//

import SwiftUI

enum CardThemeHelper {

    static let themeNames  = ["Classic", "Ocean", "Sunset"]
    static let colorNames  = ["Blue", "Green", "Orange", "Purple"]

    static func accentColor(for name: String) -> Color {
        switch name {
        case "Green":  return .green
        case "Orange": return .orange
        case "Purple": return .purple
        default:       return .blue
        }
    }

    @ViewBuilder
    static func cardBackground(for themeName: String) -> some View {
        if themeName == "Ocean" {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [.blue.opacity(0.35), .cyan.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        } else if themeName == "Sunset" {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [.orange.opacity(0.4), .pink.opacity(0.25)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
        } else {
            RoundedRectangle(cornerRadius: 16)
                .fill(.thinMaterial)
        }
    }
}
