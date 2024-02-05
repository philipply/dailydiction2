//
//  ContentView.swift
//  DailyDiction2
//
//  Created by Philipp Ley on 12.01.24.
//

// ContentView.swift

import SwiftUI

struct ContentView: View {
    @ObservedObject private var appState = AppState()
    @State private var isMenuVisible = false
    @State private var showWelcomeView = false
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        
            
            NavigationView {
                
                ZStack{
                    
                    Image("paper-texture")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .opacity(0.5)
                
                    
                VStack {
                    
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300, maxHeight: 80)
                        .padding(.top, 20)
                    
                    
                    
                    Spacer()
                    
                    Text("Hey \(appState.userName) 👋🏻")
                        .font(.custom("Hunck Small Caps", size: 38))
                        .padding()
                    
                    Text("du hast bisher \(appState.learnedWordsCount) Wörter gelernt!")
                        .font(.custom("Hunck-Regular", size: 18))
                        .padding()
                        .onAppear {
                            appState.learnedWordsCount = HistoryManager.shared.historyList.count
                        }
                        .padding(.top, -25)
                    
                    Spacer()
                    
                    VStack{
                        NavigationLink(destination: DailyWordView(currentIndex: $appState.currentIndex)
                            .environmentObject(appState)) {
                                Image("MeinHeutigesWort")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 280, maxHeight: 80)
                            }
                        
                        NavigationLink(destination: HistoryView()) {
                            Image("MeineHistorie")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 280, maxHeight: 80)
                        }
                        
                        Button(action: {
                            isMenuVisible.toggle()
                        }) {
                            Image("Themenfelder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 280, maxHeight: 80)
                        }
                        
                        NavigationLink(destination: MenuView()
                            .environmentObject(appState),
                                       isActive: $isMenuVisible) {
                            EmptyView()
                        }
                                       .hidden()
                        
                    }
                    .padding()
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.4)) {
                            self.size = 1.0
                            self.opacity = 1.0
                            
                            Spacer()
                        }
                    }
                    .environmentObject(appState)
                    Spacer()
                }.onAppear {
                    debugPrintSavedWord() // Stelle sicher, dass du auf die richtige Instanz deiner AppState-Klasse zugreifst
                }
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                appState.checkNewDay()
            }
        }
    }
    func debugPrintSavedWord() {
        let userDefaults = UserDefaults(suiteName: "group.com.ply.DailyDiction2")
        if let savedWord = userDefaults?.string(forKey: "DailyWord"),
           let savedDefinition = userDefaults?.string(forKey: "DailyWordExplanation") {
            print("Gespeichertes Wort nach Neustart: \(savedWord)")
            print("Definition des gespeicherten Wortes: \(savedDefinition)")
        } else {
            print("Kein Wort in UserDefaults gespeichert.")
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
