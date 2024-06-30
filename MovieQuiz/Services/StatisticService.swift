//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Anna Domracheva on 21.06.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGame.rawValue + BestGamesKeys.correct.rawValue)
            let total = storage.integer(forKey: Keys.bestGame.rawValue + BestGamesKeys.total.rawValue)
            let date = storage.object(forKey: Keys.bestGame.rawValue + BestGamesKeys.date.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGame.rawValue + BestGamesKeys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGame.rawValue + BestGamesKeys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGame.rawValue + BestGamesKeys.date.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        guard gamesCount != 0 else {
            return 0
        }
       return (Double(correctAnswers) / (Double(gamesCount) * 10)) * 100
    }
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correctAnswers += count
        let result = GameResult(correct: count, total: amount, date: Date())
        if result.isBetterThan(bestGame) { bestGame = result }
        
    }
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
    }
    
    private enum BestGamesKeys: String {
        case correct
        case total
        case date
    }
}
