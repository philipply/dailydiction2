//
//  AppState.swift
//  DailyDiction2
//
//  Created by Philipp Ley on 12.01.24.

import SwiftUI
import WidgetKit

class AppState: ObservableObject {
    private var timer: Timer?
    @Published var currentIndex: Int
    @Published var learnedWordsCount: Int
    @Published var selectedThemes: Set<String> {
        didSet {
            saveSelectedThemes()
        }
    }
    @Published var userName: String

    var wordList: [Word] {
        if selectedThemes.isEmpty {
            return themes.flatMap { $0.words }
        } else {
            return themes.filter { selectedThemes.contains($0.name) }
                          .flatMap { $0.words }
        }
    }
    var historyList: [String] {
        HistoryManager.shared.historyList.map { $0.word }
    }

    init() {
        self.currentIndex = UserDefaults.standard.integer(forKey: "currentIndex")
        self.learnedWordsCount = HistoryManager.shared.historyList.count
        self.selectedThemes = Set(UserDefaults.standard.stringArray(forKey: "selectedThemes") ?? [])
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        setupDailyWordUpdateTimer()
        checkNewDay()
    }
    
    func setupDailyWordUpdateTimer() {
        print("Setting up daily word update timer")
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = 0
        dateComponents.minute = 0
        let midnight = calendar.nextDate(after: Date(), matching: dateComponents, matchingPolicy: .nextTime)!
        timer = Timer(fireAt: midnight, interval: 86400, target: self, selector: #selector(checkNewDay), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        print("Timer set for midnight: \(midnight)")
    }

    @objc func checkNewDay() {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let lastUpdated = UserDefaults.standard.object(forKey: "lastUpdatedDate") as? Date ?? calendar.date(byAdding: .day, value: -1, to: currentDate)!
        let lastUpdatedStartOfDay = calendar.startOfDay(for: lastUpdated)

        if currentDate > lastUpdatedStartOfDay {
            print("A new day has started, updating the word")
            UserDefaults.standard.set(currentDate, forKey: "lastUpdatedDate")
            showNextWord()
        } else {
            print("Still the same day, no update needed")
        }
    }

    func showNextWord() {
        print("Showing the next word")
        
        let unshownWords = wordList.filter { !historyList.contains($0.word) }
        guard !unshownWords.isEmpty else {
            print("All words have been shown, no new word to display")
            return
        }

        if let nextWord = unshownWords.randomElement(),
           let index = wordList.firstIndex(where: { $0.word == nextWord.word }) {
            self.currentIndex = index
            print("New word selected: \(nextWord.word)")
            print("New word selected: \(currentIndex)")

            // Speichere das neue Wort und seine Erklärung in UserDefaults
            updateDailyWordInUserDefaults(word: nextWord)
            // Speichern des aktualisierten currentIndex in UserDefaults
            UserDefaults.standard.set(currentIndex, forKey: "currentIndex")
        } else {
            print("No new word could be selected")
        }
    }

    func updateDailyWordInUserDefaults(word: Word) {
        let userDefaults = UserDefaults(suiteName: "group.com.ply.DailyDiction2")
        userDefaults?.set(word.word, forKey: "DailyWord")
        userDefaults?.set(word.definition, forKey: "DailyWordExplanation")
        print("Daily word updated in UserDefaults: \(word.word)")

        // Debugging-Code
        let savedWord = userDefaults?.string(forKey: "DailyWord") ?? "Nicht gefunden"
        let savedDefinition = userDefaults?.string(forKey: "DailyWordExplanation") ?? "Nicht gefunden"
        print("Gespeichertes Wort: \(savedWord), Erklärung: \(savedDefinition)")
        WidgetCenter.shared.reloadAllTimelines()
    }

    
   
    func addToHistoryIfNeeded() {
        guard currentIndex != nil else { return }

        if wordList.indices.contains(currentIndex) {
            let word = wordList[currentIndex].word
            if !HistoryManager.shared.historyList.contains(where: { $0.word == word }) {
                let newEntry = HistoryEntry(word: word, date: Date())
                HistoryManager.shared.addToHistory(newEntry)
                learnedWordsCount = HistoryManager.shared.historyList.count
                print("Added word to history: \(word)")
            }
        }
    }

    func saveSelectedThemes() {
        UserDefaults.standard.set(Array(selectedThemes), forKey: "selectedThemes")
        print("Selected themes saved")
    }

    func saveUserName() {
        UserDefaults.standard.set(userName, forKey: "userName")
        print("User name saved")
    }
}
