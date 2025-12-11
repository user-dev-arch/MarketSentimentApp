//
//  WatchListViewModel.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 11/12/25.
//


import Foundation
import Combine


final class WatchListViewModel: ObservableObject {
    
    @Published var savedStocks: [String] = []
    @Published var stocks: [StocksModel] = []
    
    private let userDefualts: UserDefaultsProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(userDefualts: UserDefaultsProtocol = UserdefaultsManager(), networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.userDefualts = userDefualts
        self.networkManager = networkManager
        self.getSavedStocks()
    }
    
    
    func getStocks() async {
        do {
            let stocks: [StocksModel] = try await networkManager.fetchData(for: .stocks(limit: 100))
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.stocks = stocks
            }
        } catch {
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.stocks = PreviewModels.stockModels
            }
            print(#function, error)
        }
    }
    
    
    func getSavedStocks() {
        let array = userDefualts.getAllSavedStocks()
        self.savedStocks = array
    }
    
}
