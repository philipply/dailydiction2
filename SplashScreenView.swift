//
//  SplashScreenView.swift
//  DailyDiction2
//
//  Created by Philipp Ley on 15.01.24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @StateObject private var appState = AppState()
    
    var body: some View {
        
        ZStack{
            
            Image("paper-texture")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            
            VStack {
                if isActive {
                    
                    if isFirstLaunch {
                        WelcomeView(isFirstLaunch: $isFirstLaunch, userName: $appState.userName)
                            .onDisappear {
                                appState.saveUserName()
                            }
                    } else {
                        ContentView()
                            .environmentObject(appState)
                            .colorScheme(.light)
                    }
                    
                } else {
                    
                    VStack {
                        VStack {
                            LottieView()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 800, maxHeight: 900)
                                .padding(.top, 10)
                            
                        }
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.0)) {
                                self.size = 0.85
                                self.opacity = 1.0
                            }
                        }
                        
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline:  .now() + 3) {
                            withAnimation {
                                self.isActive = true
                            }
                            
                        }
                    }
                }
            }
            .preferredColorScheme(.light)
        }
        }
}
