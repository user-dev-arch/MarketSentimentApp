//
//  UserdefaultsManager.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 09/12/25.
//


import Foundation


protocol UserDefaultsProtocol {
    func saveStock(ticker: String)
    func isStockSaved(ticker: String) -> Bool
    func removeStock(ticker: String)
    func getAllSavedStocks() -> [String]
}


final class UserdefaultsManager: UserDefaultsProtocol {
    private let userDefaults = UserDefaults.standard
    
    
    enum Keys: String {
        case savedStocks = "savedStocks"
    }
    
    init() {
        let defaultKeys: [String: Any] = [
            Keys.savedStocks.rawValue: []
        ]
        userDefaults.register(defaults: defaultKeys)
    }
    
    func saveStock(ticker: String) {
        guard var array: [String] = userDefaults.object(forKey: Keys.savedStocks.rawValue) as? [String] else { return }
        array.append(ticker)
        userDefaults.set(array, forKey: Keys.savedStocks.rawValue)
    }
    
    
    func isStockSaved(ticker: String) -> Bool {
        guard let array: [String] = userDefaults.object(forKey: Keys.savedStocks.rawValue) as? [String] else { return false }
        return array.contains(where: { $0 == ticker })
    }
    
    func removeStock(ticker: String) {
        guard var array: [String] = userDefaults.object(forKey: Keys.savedStocks.rawValue) as? [String] else { return }
        array.removeAll(where: { $0 == ticker })
        userDefaults.set(array, forKey: Keys.savedStocks.rawValue)
    }
    
    
    func getAllSavedStocks() -> [String] {
        guard let array: [String] = userDefaults.object(forKey: Keys.savedStocks.rawValue) as? [String] else { return [] }
        return array
    }
    
}
