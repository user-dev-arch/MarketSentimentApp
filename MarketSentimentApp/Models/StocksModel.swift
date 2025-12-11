//
//  StocksModel.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 04/12/25.
//


import Foundation



struct StocksModel: Decodable, Hashable {
    let ticker: String
    let companyFullName: String
    let changeInDay: String
    let currentPrice: String
    let sentimentScore: Int?
}



struct StockDetailsModel: Decodable {
    let companyFullName: String
    let price: Double
    let changeInDay: Double
    let marketCap: String
    let volume: String
    let newsBuzz: String
    let pricesHistory: [Double]
    let newsSentiment: SentimentCardModel
    let recentNews: [NewsModel]
}


struct SentimentCardModel: Decodable {
    let bullish: Int
    let bearish: Int
    let neutral: Int
}
