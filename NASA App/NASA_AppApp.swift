//
//  NASA_AppApp.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import Foundation
import SwiftUI

@main
struct NASAApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.theme.colorScheme)
        }
    }
}
