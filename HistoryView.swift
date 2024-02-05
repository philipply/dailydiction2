import SwiftUI

struct HistoryView: View {
    @ObservedObject var historyManager = HistoryManager.shared
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                
                Image("paper-texture")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.5)
                
                VStack {
                    Text("Historie deiner Wörter")
                        .font(Font.custom("HunckSC-Regular", size: 30))
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Image("Strich")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 370, maxHeight: 80)
                        .padding(.top, -60)
                    
                    // Abgerundetes weißes Rechteck um die Liste
                    VStack {
                        List {
                            ForEach(historyManager.historyList.reversed(), id: \.word) { entry in
                                VStack(alignment: .leading) {
                                    Text(entry.word)
                                        .font(Font.custom("HunckSC-Regular", size: 22))
                                    
                                    Text(wordList.first { $0.word == entry.word }?.definition ?? "")
                                        .font(Font.custom("Hunck-Regular", size: 16))
                                        .foregroundColor(.gray)
                                }
                                .listRowBackground(Color.white) // Setzt den Hintergrund jeder Zeile auf Weiß
                            }
                            .onDelete { indexSet in
                                historyManager.historyList.remove(atOffsets: indexSet)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .background(Color("BackgroundColor")) // Setzt den Hintergrund des VStacks auf Weiß
                    .cornerRadius(15) // Abgerundete Ecken für das weiße Rechteck
                    .shadow(radius: 1.5) // Optional: Fügt einen Schatten hinzu, um Tiefe zu erzeugen
                    .padding()
    
                    
                    Button("Fortschritt zurücksetzen") {
                        showAlert = true
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .font(Font.custom("Hunck-Regular", size: 16))
                    .padding()
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Fortschritt zurücksetzen"),
                            message: Text("Möchtest du wirklich deinen gesamten Fortschritt zurücksetzen?"),
                            primaryButton: .destructive(Text("Zurücksetzen")) {
                                historyManager.historyList.removeAll()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Vermeidet Probleme mit der Darstellung auf dem iPad
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
