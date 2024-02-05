//
//  DailyWordView.swift
//  DailyDiction2
//
//  Created by Philipp Ley on 12.01.24.
//

import SwiftUI

struct DailyWordView: View {
    @Binding var currentIndex: Int
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack{
            
            Image("paper-texture")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            
            VStack {
                
                
                Text("Dein heutiges Wort")
                    .font(.custom("Hunck Small Caps", size: 30))
                    .lineLimit(nil)
                    .padding()
                
                Image("Strich")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300, maxHeight: 80)
                    .padding(.top, -60)
                
                Spacer()
                
                
                    VStack(alignment: .center, spacing: -10) {
                        
                        
                        
                        if let currentWord = appState.wordList[safe: appState.currentIndex] {
                            Text(currentWord.word)
                                .font(Font.custom("Hunck Small Caps", size: 35))
                                .padding()
                            
                            Text(currentWord.definition)
                                .font(Font.custom("Hunck-Regular", size: 17))
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    .padding(1)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color("ButtonColor")))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 2)
                            .shadow(radius: 1.3)
                            
                    )
                    .padding(15)
                
                Spacer()
                
                Button("das Wort kenne ich schon!", action: {
                    appState.showNextWord()
                    
                    if let currentWord = appState.wordList[safe: appState.currentIndex] {
                        appState.addToHistoryIfNeeded()
                    }
                })
                .padding(10)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 1.7)
                .font(Font.custom("UbuntuSans-Regular", size: 17))
                
                Spacer()
            }
        }
            
        }
        
    }
    
    
    struct DailyWordView_Previews: PreviewProvider {
        static var previews: some View {
            DailyWordView(currentIndex: .constant(0))
                .environmentObject(AppState())
        }
    }
    extension Collection {
        subscript(safe index: Index) -> Element? {
            indices.contains(index) ? self[index] : nil
        }
    }
