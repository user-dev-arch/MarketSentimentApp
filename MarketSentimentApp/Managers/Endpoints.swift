//
//  Endpoints.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 04/12/25.
//


import Foundation


enum HTTPMethod: String {
    case get  = "GET"
    case post = "POST"
}


enum Sentiment: String {
    case bullish = "Bullish"
    case bearish = "Bearish"
    case neutral = "Neutral"
}



enum Endpoint {
    case topMovers(limit: Int?)
    case newsBuzz(limit: Int?)
    case sentimentMovers(limit: Int?)
    case stocks(limit: Int?)
    case news(limit: Int?, sentiment: Sentiment?, stocks: String?, timePeriod: String)
    case sentiment(id: String)
    case stockDetails(ticker: String)

    private static let baseURL: URL? = URL(string: "https://ai-appstudio.jprq.live")

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .topMovers: return "/topMovers"
        case .newsBuzz: return "/newsBuzz"
        case .sentimentMovers: return "/sentimentMovers"
        case .stocks: return "/stocks"
        case .news: return "/news"
        case .sentiment(let id): return "/sentiment/\(id)"
        case .stockDetails: return "/stock-details"
        }
    }

    func headers() -> [String: String] {
        var h: [String: String] = [:]
        if method == .post { h["Content-Type"] = "application/json" }
        return h
    }
    
    
    private var limitValue: Int? {
        switch self {
        case .topMovers(let limit),
                .newsBuzz(let limit),
                .sentimentMovers(let limit),
                .stocks(let limit),
                .news(let limit, _, _, _):
            return limit
        default: return nil
        }
    }
    
    
    private var sentimentQueryValue: String? {
        switch self {
        case .news(_,let sentiment,_,_):
            return sentiment?.rawValue
        default: return nil
        }
    }
    
    
    private var stocksQueryValue: String? {
        switch self {
        case .news(_, _,let stocks,_):
            return stocks
        default: return nil
        }
    }
    
    
    private var timePeriodQueryValue: String? {
        switch self {
        case .news(_, _, _,let timePeriod):
            return timePeriod
        default: return nil
        }
    }
    
    
    private var tickerQueryValue: String? {
        switch self {
        case .stockDetails(let ticker):
            return ticker
        default: return nil
        }
    }
    
    
    
    var queryItems: [URLQueryItem]? {
        var queryList: [URLQueryItem] = []
        
        if let limit = limitValue {
            queryList.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }
        
        if let sentimentValue = sentimentQueryValue {
            queryList.append(URLQueryItem(name: "sentiment", value: sentimentValue))
        }
        
        if let stocksValue = stocksQueryValue {
            queryList.append(URLQueryItem(name: "stocks", value: stocksValue))
        }
        
        if let timePeriodValue = timePeriodQueryValue {
            queryList.append(URLQueryItem(name: "timePeriod", value: timePeriodValue))
        }
        
        if let tickerValue = tickerQueryValue {
            queryList.append(URLQueryItem(name: "ticker", value: tickerValue))
        }
        
        return queryList
    }
    
    
    func urlRequest() throws -> URLRequest {
        guard let base = Endpoint.baseURL else {
            throw URLError(.badURL)
        }

        
        var components = URLComponents(url: base.appendingPathComponent(path),
                                             resolvingAgainstBaseURL: false)
        components?.queryItems = self.queryItems
        
        guard let finalURL = components?.url else {
            throw URLError(.badURL)
        }
        
        print("url: ", finalURL.absoluteString)
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        headers().forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}

