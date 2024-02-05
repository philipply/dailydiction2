//
//  WelcomeView.swift
//  DailyDiction2
//
//  Created by Philipp Ley on 14.01.24.
//

// WelcomeView.swift

// WelcomeView.swift

import SwiftUI

struct WelcomeView: View {
    @Binding var isFirstLaunch: Bool
    @Binding var userName: String
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        
        

        ZStack{
            
            Image("paper-texture")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            
            VStack {
                
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 250, maxHeight: 80)
                    .padding(.top, 20)
                
                Spacer()
                
                
                Text("Willkommen!")
                    .font(Font.custom("HunckSC-Regular", size: 45))
                
                Text("Wie möchtest du genannt werden?")
                    .font(Font.custom("HunckSC-Regulark", size: 18))
                
                
                
                Spacer()
                
                VStack {
                    TextField("Dein Name", text: $userName)
                    //.textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(10)
                        .background(Color.gray.opacity(0.3).cornerRadius(10))
                        .foregroundColor(.black)
                        .font(Font.custom("HunckSC-Regular", size: 25))
                    
                    Button(action: {
                        // Verzögert die Ausführung des Codeblocks um 2 Sekunden
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isFirstLaunch = false
                            UserDefaults.standard.set(userName, forKey: "userName")
                        }
                    }) {
                        Image("Weiter") // Hier wird das Bild für den Button eingefügt
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    .padding()
                    .preferredColorScheme(.light)
                    
                    
                }
                .padding()
                .onAppear {
                    withAnimation(.easeIn(duration: 3.0)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
        }
    }
}
