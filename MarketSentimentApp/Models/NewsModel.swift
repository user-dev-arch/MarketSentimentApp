//
//  NewsModel.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 04/12/25.
//

import Foundation


struct NewsModel: Decodable, Hashable {
    let id: String
    let ticker: String
    let title: String
    let content: String
    let source: String
    let author: String?
    let sentiment: String?
    let date: Date
    let link: String
}


struct SentimentReport: Decodable {
    let sentiment: String
}
