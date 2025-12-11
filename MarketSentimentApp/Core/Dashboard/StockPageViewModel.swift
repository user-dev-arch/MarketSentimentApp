//
//  StockPageViewMode.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 09/12/25.
//

import Foundation
import Combine


final class StockPageViewModel: ObservableObject {
    
    @Published var stockDetailsModel: StockDetailsModel? = nil
    @Published var isStockSaved: Bool = false
    
    private let networkManager: NetworkManagerProtocol
    private let userDefaults: UserDefaultsProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager(), userDefaults: UserDefaultsProtocol = UserdefaultsManager()) {
        self.networkManager = networkManager
        self.userDefaults = userDefaults
    }
    
    
    func getStocksDetails(ticker: String) async {
        do {
            let stockDetails: StockDetailsModel = try await networkManager.fetchData(for: .stockDetails(ticker: ticker))
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.stockDetailsModel = stockDetails
            }
        } catch {
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.stockDetailsModel = PreviewModels.stockDetailsModel
            }
            print(#function, error)
        }
    }
    
    func isStockSaved(ticker: String) {
        isStockSaved = userDefaults.isStockSaved(ticker: ticker)
    }
    
    func saveStock(ticker: String) {
        userDefaults.saveStock(ticker: ticker)
        isStockSaved(ticker: ticker)
    }
    
    func deleteSavedStock(ticker: String) {
        userDefaults.removeStock(ticker: ticker)
        isStockSaved(ticker: ticker)
    }
}
