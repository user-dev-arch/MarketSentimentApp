//
//  DashboardViewModel.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 05/12/25.
//


import SwiftUI
import Combine



final class DashboardViewModel: ObservableObject {
    
    @Published var topMovers: [TopMoversModel] = []
    @Published var newsBuzz: [NewsBuzzModel] = []
    @Published var sentimentMovers: [SentimentMoversModel] = []
    
    @Published var stocks: [StocksModel] = []
    
    private let networkManager: NetworkManagerProtocol
    
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    
    func getTopMovers() async {
        do {
            let topMovers: [TopMoversModel] = try await networkManager.fetchData(for: .topMovers(limit: 3))
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.topMovers = topMovers
            }
        } catch {
            print(#function, error)
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.topMovers = PreviewModels.topMoversList
            }
        }
    }
    
    
    func getNewsBuzz() async {
        do {
            let newsBuzz: [NewsBuzzModel] = try await networkManager.fetchData(for: .newsBuzz(limit: 3))
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.newsBuzz = newsBuzz
            }
        } catch {
            print(#function, error)
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.newsBuzz = PreviewModels.newsBuzzModels
            }
        }
    }
    
    
    func getSentimentMovers() async {
        do {
            let sentimentMovers: [SentimentMoversModel] = try await networkManager.fetchData(for: .sentimentMovers(limit: 3))
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.sentimentMovers = sentimentMovers
            }
        } catch {
            print(#function, error)
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.sentimentMovers = PreviewModels.sentimentMoversModels
            }
        }
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
    
}
