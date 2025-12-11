//
//  TopMoversModel.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 04/12/25.
//

import Foundation


enum NewsTimePeriod: String {
    case last24Hours = "24h"
    case last7Days = "7d"
}


enum SentimentScore: Int {
    case bearish = 0
    case neutral = 1
    case bullish = 2
    
    
    var sentimentString: String {
        switch self {
        case .bearish:
            return "Bearish"
        case .neutral:
            return "Neutral"
        case .bullish:
            return "Bullish"
        }
    }
    
    var convertToSentiment: Sentiment {
        switch self {
        case .bearish:
            return .bearish
        case .neutral:
            return .neutral
        case .bullish:
            return .bullish
        }
    }
}


struct TopMoversModel: Decodable, Hashable {
    let ticker: String
    let change: String
    let currentPrice: String
}


struct NewsBuzzModel: Decodable, Hashable {
    let ticker: String
    let score: String
    let companyFullName: String
}


struct SentimentMoversModel: Decodable, Hashable {
    let ticker: String
    let change: Double
    let sentimentScore: Int
}



extension SentimentMoversModel {
    func sentimentValue() -> Sentiment {
        switch self.sentimentScore {
        case 0: return .bearish
        case 2: return .bullish
        default: return .neutral
        }
    }
}
