//
//  ThemeManager.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import SwiftUI
import Combine
import UIKit

enum AppTheme: String, CaseIterable, Codable {
    case light
    case dark

    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    mutating func toggleLightDark() {
        switch self {
        case .light:
            self = .dark
        case .dark:
            self = .light
        }
    }

    var iconName: String {
        switch self {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
    
    static var systemTheme: AppTheme {
        let deviceTheme = UITraitCollection.current.userInterfaceStyle
        return deviceTheme == .dark ? .dark : .light
    }
}

@MainActor
final class ThemeManager: ObservableObject {
    @Published var theme: AppTheme {
        didSet {
            save()
            hasUserSetTheme = true
        }
    }

    private let storageKey = "NasaAppTheme.selection"
    private let hasUserSetThemeKey = "NasaAppTheme.hasUserSetTheme"
    private var hasUserSetTheme: Bool {
        get { UserDefaults.standard.bool(forKey: hasUserSetThemeKey) }
        set { UserDefaults.standard.set(newValue, forKey: hasUserSetThemeKey) }
    }

    init() {
        let hasManualSelection = UserDefaults.standard.bool(forKey: hasUserSetThemeKey)
        
        if hasManualSelection,
           let raw = UserDefaults.standard.string(forKey: storageKey),
           let savedTheme = AppTheme(rawValue: raw) {
            self.theme = savedTheme
        } else {
            let deviceTheme = UITraitCollection.current.userInterfaceStyle
            self.theme = deviceTheme == .dark ? .dark : .light
        }
    }

    func toggleLightDark() {
        theme.toggleLightDark()
    }

    private func save() {
        UserDefaults.standard.set(theme.rawValue, forKey: storageKey)
    }
}
