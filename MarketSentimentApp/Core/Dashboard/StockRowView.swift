//
//  StockRowView.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 11/12/25.
//


import SwiftUI


struct StockRowView: View {
    @StateObject private var vm = StockPageViewModel()
    
    let stock: StocksModel

    var body: some View {
        HStack(spacing: 16) {
            // Left: ticker + company
            VStack(alignment: .leading, spacing: 6) {
                Text(stock.ticker)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(stock.companyFullName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: 180, alignment: .leading)
            }

            Spacer()

            // Right: price, change, sentiment bar, star
            HStack(alignment: .center, spacing: 12) {
                // Price & change
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(stock.currentPrice)")
                        .font(.headline)
                        .foregroundColor(.white)

                    // changeInDay displayed with arrow and colored
                    let changeValue = parseChange(stock.changeInDay)
                    HStack(spacing: 6) {
                        Image(systemName: changeValue >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption2)
                        Text(stock.changeInDay)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(changeValue >= 0 ? Color.green : Color.red)
                }

                // Favorite/star button (visual only)
                Button(action: {
                    if vm.isStockSaved {
                        vm.deleteSavedStock(ticker: stock.ticker)
                    } else {
                        vm.saveStock(ticker: stock.ticker)
                    }
                }) {
                    Image(systemName: vm.isStockSaved ? "star.fill" : "star")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .foregroundStyle(vm.isStockSaved ? Color.yellow : .white)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.sRGB, white: 0.06)))
                }
                .buttonStyle(.plain)
            }
            .frame(minWidth: 260, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.sRGB, white: 0.04))
                .shadow(color: Color.black.opacity(0.35), radius: 6, x: 0, y: 4)
        )
        .task {
            await MainActor.run {
                vm.isStockSaved(ticker: stock.ticker)
            }
        }
    }

    // MARK: - Helpers (kept inside view only, no extra structs)

    private var clampedSentiment: Double {
        let s = Double(stock.sentimentScore ?? 50)
        return min(max(s / 100.0, 0.0), 1.0)
    }

    private var sentimentText: String {
        let val = stock.sentimentScore ?? 0
        return (val >= 0 ? "+" : "") + "\(val)"
    }

    private var sentimentColor: Color {
        let val = stock.sentimentScore ?? 0
        return val >= 0 ? Color.green : Color.red
    }

    private func parseChange(_ text: String) -> Double {
        // remove % and + signs and try parse; fallback to 0
        let cleaned = text.replacingOccurrences(of: "%", with: "")
                         .replacingOccurrences(of: "+", with: "")
                         .replacingOccurrences(of: ",", with: "")
                         .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(cleaned) ?? 0.0
    }
}
