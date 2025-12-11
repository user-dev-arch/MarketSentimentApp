//
//  NewsViewModel.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 08/12/25.
//


import Foundation

@Observable
final class NewsViewModel {
    var selectedSentiment: SentimentScore? = nil {
        didSet {
            updateFilter()
        }
    }
    var selectedStock: StocksModel? = nil {
        didSet {
            updateFilter()
        }
    }
    var selectedTimePeriod: NewsTimePeriod = .last24Hours {
        didSet {
            updateFilter()
        }
    }
    
    var stocks: [StocksModel] = []
    var news: [NewsModel] = []
    
    @ObservationIgnored private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
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
    
    
    func getNewsModels() async {
        do {
            let news: [NewsModel] = try await networkManager.fetchData(for: .news(limit: 100, sentiment: selectedSentiment?.convertToSentiment, stocks: selectedStock?.ticker, timePeriod: selectedTimePeriod.rawValue))
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.news = news
            }
        } catch {
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.news = PreviewModels.mockNews
            }
            print(#function, error)
        }
    }
    
    
    func updateFilter() {
        Task {
            await self.getNewsModels()
        }
    }
}
