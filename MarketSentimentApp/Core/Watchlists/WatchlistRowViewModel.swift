//
//  WatchlistRowViewModel.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 10/12/25.
//



import Foundation
import Combine


final class WatchlistRowViewModel: ObservableObject {
    
    @Published var stockDetails: StockDetailsModel? = nil
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getStocksDetails(ticker: String) async {
        do {
            let stockDetails: StockDetailsModel = try await networkManager.fetchData(for: .stockDetails(ticker: ticker))
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.stockDetails = stockDetails
            }
        } catch {
//            await MainActor.run { [weak self] in
//                guard let self = self else { return }
//                self.stockDetails = PreviewModels.stockDetailsModel
//            }
            print(#function, error)
        }
    }
    
}
