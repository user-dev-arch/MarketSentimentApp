//
//  PreviewModels.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 04/12/25.
//



import Foundation


final class PreviewModels {
    
    static var topMoversList: [TopMoversModel] {
        [
//            TopMoversModel(ticker: "AMD", change: 7.19, currentPrice: 132.89),
//            TopMoversModel(ticker: "NVDA", change: 4.22, currentPrice: 140.15),
//            TopMoversModel(ticker: "TSLA", change: -3.27, currentPrice: 242.84)
        ]
    }
    
    
    static var newsBuzzModels: [NewsBuzzModel] {
        [
//            NewsBuzzModel(ticker: "TSLA", score: 0.98, companyFullName: "Tesla, Inc."),
//            NewsBuzzModel(ticker: "GOOGL", score: 0.94, companyFullName: "Alphabet Inc."),
//            NewsBuzzModel(ticker: "AMD", score: 0.91, companyFullName: "Advanced Micro Devices")
        ]
    }
    
    
    static var sentimentMoversModels: [SentimentMoversModel] {
        [
            SentimentMoversModel(ticker: "TSLA", change: -42, sentimentScore: -35),
            SentimentMoversModel(ticker: "AMD", change: 35, sentimentScore: 76),
            SentimentMoversModel(ticker: "META", change: 28, sentimentScore: 55)
        ]
    }
    
    static var stockModels: [StocksModel] {
        []
//        [
//            StocksModel(
//                ticker: "AAPL",
//                companyFullName: "Apple Inc.",
//                changeInDay: 1.24,
//                currentPrice: 195.32,
//                sentimentScore: 78
//            ),
//            StocksModel(
//                ticker: "TSLA",
//                companyFullName: "Tesla, Inc.",
//                changeInDay: -2.87,
//                currentPrice: 239.54,
//                sentimentScore: 55
//            ),
//            StocksModel(
//                ticker: "AMZN",
//                companyFullName: "Amazon.com, Inc.",
//                changeInDay: 0.98,
//                currentPrice: 177.62,
//                sentimentScore: 82
//            ),
//            StocksModel(
//                ticker: "GOOGL",
//                companyFullName: "Alphabet Inc.",
//                changeInDay: 2.11,
//                currentPrice: 142.11,
//                sentimentScore: 73
//            ),
//            StocksModel(
//                ticker: "MSFT",
//                companyFullName: "Microsoft Corporation",
//                changeInDay: 0.57,
//                currentPrice: 415.67,
//                sentimentScore: 88
//            )
//        ]
    }
    
    
    static var mockNews: [NewsModel] {
        []
//        [
//            NewsModel(
//                id: UUID().uuidString,
//                ticker: "AAPL",
//                title: "Apple Unveils New MacBook Lineup",
//                content: "Apple has introduced a new line of MacBook devices focused on performance and battery efficiency.",
//                source: "Bloomberg",
//                author: "Jane Doe",
//                sentiment: "Bearish",
//                date: Date(),
//                link: "https://example.com/apple-macbook-news"
//            ),
//            NewsModel(
//                id: UUID().uuidString,
//                ticker: "TSLA",
//                title: "Tesla Expands Gigafactory Production",
//                content: "Tesla announces expansion plans for their Gigafactory to increase EV production capacity.",
//                source: "Reuters",
//                author: "John Smith",
//                date: Calendar.current.date(byAdding: .hour, value: -5, to: Date())!,
//                link: "https://example.com/tesla-gigafactory-update"
//            ),
//            NewsModel(
//                id: UUID().uuidString,
//                ticker: "AMZN",
//                title: "Amazon Launches New Delivery Drones",
//                content: "Amazon is rolling out autonomous drones across key cities to improve delivery efficiency.",
//                source: "TechCrunch",
//                author: "Emily Carter",
//                date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
//                link: "https://example.com/amazon-drone-news"
//            ),
//            NewsModel(
//                id: UUID().uuidString,
//                ticker: "MSFT",
//                title: "Microsoft Announces AI Cloud Tools",
//                content: "Microsoft expands its AI cloud portfolio with new developer tools and enterprise services.",
//                source: "The Verge",
//                author: "Michael Lee",
//                date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
//                link: "https://example.com/microsoft-ai-tools"
//            )
//        ]
    }
    
    
    static var stockDetailsModel: StockDetailsModel {
        StockDetailsModel(companyFullName: "Apple Inc,", price: 128.90, changeInDay: -8.0, marketCap: "3.65T", volume: "847", newsBuzz: "92", pricesHistory: [127, 126, 129, 130, 140, 128, 124, 123, 123, 140], newsSentiment: SentimentCardModel(bullish: 110, bearish: 10, neutral: 23), recentNews: mockNews)
    }
    
}
