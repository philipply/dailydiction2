//
//  StartScreenView.swift
//  DailyDiction2
//
//  Created by Philipp Ley on 14.01.24.
//

import SwiftUI

struct StartScreenView: View {
    @StateObject private var userData = UserData.shared
    @State private var showMainApp = false

    var body: some View {
        VStack {
            Text("Willkommen!")
                .font(.title)
                .padding()

            TextField("Dein Name", text: $userData.name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Weiter", action: {
                showMainApp.toggle()
            })
            .padding()
            .disabled(userData.name.isEmpty)

        }
        .fullScreenCover(isPresented: $showMainApp, content: {
            ContentView()
                .environmentObject(AppState())
        })
        .padding()
    }
}
