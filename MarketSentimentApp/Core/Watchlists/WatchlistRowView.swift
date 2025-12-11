//
//  Untitled.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 10/12/25.
//


import SwiftUI


struct WatchlistRowView: View {
    @StateObject private var vm = WatchlistRowViewModel()
    let stockTicker: String
    
    var body: some View {
        VStack {
            HeaderView()
        }
        .frame(maxWidth: .infinity)
        .task {
            await vm.getStocksDetails(ticker: stockTicker)
        }
    }
    
    
    func changePercentString(details: StockDetailsModel) -> String {
        let base = details.price - details.changeInDay
        guard base != 0 else { return "" }
        let pct = (details.changeInDay / base) * 100
        return String(format: "(%+.2f%%)", pct)
    }
    
    @ViewBuilder private func HeaderView() -> some View {
        
        let details = vm.stockDetails ?? PreviewModels.stockDetailsModel
        
        VStack(spacing: 14) {
            HStack(alignment: .top) {
                // Left column: ticker + star + company name
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .center, spacing: 10) {
                        Text(stockTicker)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                    }

                    Text(vm.stockDetails?.companyFullName ?? "")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(hex: "9AA3A9"))
                }

                Spacer()

                // Right column: price + change
                VStack(alignment: .trailing, spacing: 6) {
                    Text("$" + details.price.formattedCurrency)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    HStack(spacing: 8) {
                        Image(systemName: details.changeInDay >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(details.changeInDay >= 0 ? Color.greenAccent : Color.redAccent)

                        Text(details.changeInDay >= 0 ? "+\(details.changeInDay.formatTwo)" : details.changeInDay.formatTwo)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(details.changeInDay >= 0 ? Color.greenAccent : Color.redAccent)

                        Text(changePercentString(details: details))
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor((details.changeInDay >= 0 ? Color.greenAccent : Color.redAccent).opacity(0.9))
                    }
                }
            }
            NewsSentimentCard(sentimentScores: details.newsSentiment)

            Divider().background(Color(hex: "222A32").opacity(0.6))

            HStack {
                VStack(alignment: .center, spacing: 4) {
                    Text(details.volume)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Text("Volume")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "8F989E"))
                }

                Spacer()

                // News Buzz with orange progress bar and percent to the right
                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 10) {
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(hex: "171B1F"))
                                .frame(height: 10)
                                .overlay(Capsule().stroke(Color.cardBorder, lineWidth: 0.5))

                            Capsule()
                                .fill(Color(hex: "FF7A2D"))
                                .frame(width: progressWidth(for: newsBuzzPercent(details: details)), height: 10)
                                .mask(Capsule())
                        }
                        .frame(width: 160, height: 10)

                        Text(details.newsBuzz)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    Text("News Buzz")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "8F989E"))
                }
            }
            .padding(.top, 2)
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.cardBorder, lineWidth: 1))
    }
    
    func newsBuzzPercent(details: StockDetailsModel) -> Double {
        Double(details.newsBuzz.replacingOccurrences(of: "%", with: "")) ?? 0.0
    }
    
    private func progressWidth(for percent: Double) -> CGFloat {
        // maps percent (0..100) to width of capsule (160 is full width used above)
        let maxWidth: CGFloat = 160
        let safe = max(0, min(100, percent))
        return maxWidth * CGFloat(safe / 100.0)
    }
    
}
