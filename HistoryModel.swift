//
//  HistoryModel.swift
//  DailyDiction2
//
//  Created by Philipp Ley on 12.01.24.
//

import Foundation

struct HistoryEntry: Codable, Hashable {
    var word: String
    var date: Date
}

class HistoryManager: ObservableObject {
    static let shared = HistoryManager()
    private let historyKey = "HistoryKey"

    @Published var historyList: [HistoryEntry] {
        didSet {
            saveHistoryList()
        }
    }

    init() {
        self.historyList = []
        loadHistoryList()
    }

    func addToHistory(_ entry: HistoryEntry) {
        historyList = [entry] + historyList
    }

    internal func saveHistoryList() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(historyList) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }

    private func loadHistoryList() {
        if let data = UserDefaults.standard.data(forKey: historyKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([HistoryEntry].self, from: data) {
                self.historyList = decoded
                return
            }
        }
        self.historyList = []
    }
}
