//
//  DailyDiction2App.swift
//  DailyDiction2
//
//  Created by Philipp Ley on 12.01.24.
//

import SwiftUI

@main
struct DailyDiction2App: App {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
