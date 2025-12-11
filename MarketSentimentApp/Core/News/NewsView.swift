//
//  NewsView.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 04/12/25.
//


import SwiftUI

struct NewsView: View {
    @State private var observer = NewsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                filterCard()
                articlesHeader()
                articlesList()
            }
            .padding()
        }
        .background(Color(.csBackground))
        .navigationTitle("News")
        .task {
            await observer.getStocks()
            await observer.getNewsModels()
        }
        .navigationDestination(for: String.self) { ticker in
            StockPageView(stockTicker: ticker)
        }

    }
    
    // MARK: - Filter Card
    @ViewBuilder
    private func filterCard() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "line.horizontal.3.decrease.circle")
                Text("Filter News")
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 12) {
                // Sentiment Menu
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sentiment")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Menu {
                        Button("All Sentiment") { observer.selectedSentiment = nil }
                        Button(SentimentScore.bullish.sentimentString) { observer.selectedSentiment = .bullish }
                        Button(SentimentScore.neutral.sentimentString) { observer.selectedSentiment = .neutral }
                        Button(SentimentScore.bearish.sentimentString) { observer.selectedSentiment = .bearish }
                    } label: {
                        HStack {
                            Text(observer.selectedSentiment?.sentimentString ?? "All Sentiment")
                                .lineLimit(1)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.25)))
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Stock Menu
                VStack(alignment: .leading, spacing: 6) {
                    Text("Stock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Menu {
                        Button("All Stocks") { observer.selectedStock = nil }
                        ForEach(observer.stocks, id: \.ticker) { s in
                            Button("\(s.ticker) — \(s.companyFullName)") { observer.selectedStock = s }
                        }
                    } label: {
                        HStack {
                            Text(observer.selectedStock?.ticker ?? "All Stocks")
                                .lineLimit(1)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.25)))
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Time Period Menu
                VStack(alignment: .leading, spacing: 6) {
                    Text("Time Period")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Menu {
                        Button("24 Hours") { observer.selectedTimePeriod = .last24Hours }
                        Button("7 Days") { observer.selectedTimePeriod = .last7Days }
                    } label: {
                        HStack {
                            Text(observer.selectedTimePeriod.rawValue == "24h" ? "24 Hours" : "7 Days")
                                .lineLimit(1)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.25)))
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.tertiarySystemFill)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.06)))
    }
    
    // MARK: - Header
    @ViewBuilder
    private func articlesHeader() -> some View {
        HStack {
            Text("\(observer.news.count) Articles")
                .font(.title3.weight(.semibold))
            Spacer()
            Text("Sorted by most recent")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 4)
    }
    
    // MARK: - Articles List
    @ViewBuilder
    private func articlesList() -> some View {
        LazyVStack(spacing: 14) {
            ForEach(observer.news, id: \.id) { article in
                articleRow(article)
            }
        }
    }
    
    // MARK: - Single Article Row
    @ViewBuilder
    private func articleRow(_ article: NewsModel) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                // ticker badge
                NavigationLink(value: article.ticker) {
                    Text("$\(article.ticker)")
                        .font(.caption2.weight(.semibold))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color.blue.opacity(0.12)))
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
                
                // title
                Text(article.title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                
                // excerpt
                Text(article.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    Text(article.source)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(relativeTime(from: article.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // sentiment badge on right
            VStack {
                sentimentBadge(for: article)
                Spacer()
                
                Group {
                    if let url = URL(string: article.link) {
                        Link(destination: url) {
                            HStack {
                                Text("Read")
                                
                                Image(systemName: "arrow.up.forward.square.fill")
                            }
                            .font(.headline)
                        }
                    } else {
                        Text("Read")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom)
                .tint(.accentColor)
            }
            .padding(.top, 8)
            .padding(.trailing, 8)
        }
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.tertiarySystemFill)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.06)))
    }
    
    // MARK: - Sentiment Badge
    @ViewBuilder
    private func sentimentBadge(for article: NewsModel) -> some View {
        // Since NewsModel doesn't carry sentiment, we infer in previews by keywords.
        let titleLower = article.title.lowercased()
        let bullishKeywords = ["surge", "revenue", "boost", "revolutionary", "expand", "gains"]
        let bearishKeywords = ["challenge", "delay", "drop", "decline", "concern", "cut"]
        
        let isBullish = article.sentiment == "Bullish"
        let isBearish = article.sentiment == "Bearish"
        
        if isBullish {
            HStack(spacing: 6) {
                Image(systemName: "arrow.up.right")
                Text(SentimentScore.bullish.sentimentString)
                    .font(.caption2).bold()
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.12)))
            .foregroundColor(.green)
        } else if isBearish {
            HStack(spacing: 6) {
                Image(systemName: "arrow.down.left")
                Text(SentimentScore.bearish.sentimentString)
                    .font(.caption2).bold()
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.red.opacity(0.08)))
            .foregroundColor(.red)
        } else {
            HStack(spacing: 6) {
                Image(systemName: "minus")
                Text(SentimentScore.neutral.sentimentString)
                    .font(.caption2).bold()
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.09)))
            .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Helpers
    private func relativeTime(from date: Date) -> String {
        let now = Date()
        let seconds = Int(now.timeIntervalSince(date))
        if seconds < 60 { return "\(seconds)s ago" }
        if seconds < 3600 { return "\(seconds / 60)m ago" }
        if seconds < 86400 { return "\(seconds / 3600)h ago" }
        let days = seconds / 86400
        return days == 1 ? "1 day ago" : "\(days)d ago"
    }
}

// MARK: - Preview
#Preview {
    NewsView()
}
