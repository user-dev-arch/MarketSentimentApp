//
//  StockPageView.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 05/12/25.
//

import SwiftUI

struct StockPageView: View {
    @StateObject private var vm = StockPageViewModel()
    let stockTicker: String

    var body: some View {
        ZStack {
            Color(hex: "0B0F14").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    if let details = vm.stockDetailsModel {
                        HeaderCard(stockTicker: stockTicker, details: details)
                            .frame(maxWidth: .infinity)
                        // other sections (chart / sentiment / news) go here...
                        PriceChartCard(prices: details.pricesHistory)
                        NewsSentimentCard(sentimentScores: details.newsSentiment)
                        RecentNewsList(recentNews: details.recentNews)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 220)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .frame(maxWidth: .infinity)
            }
        }
        .environmentObject(vm)
        .onAppear(perform: {
            vm.isStockSaved(ticker: stockTicker)
        })
        .task {
            await vm.getStocksDetails(ticker: stockTicker)
        }
    }
}

// MARK: Header Card (matches screenshot layout)

private struct HeaderCard: View {
    let stockTicker: String
    let details: StockDetailsModel
    @EnvironmentObject private var vm: StockPageViewModel

    var changePercentString: String {
        let base = details.price - details.changeInDay
        guard base != 0 else { return "" }
        let pct = (details.changeInDay / base) * 100
        return String(format: "(%+.2f%%)", pct)
    }

    var newsBuzzPercent: Int {
        Int((Double(details.newsBuzz) ?? 0.0) * 100)
    }

    var body: some View {
        VStack(spacing: 14) {
            HStack(alignment: .top) {
                // Left column: ticker + star + company name
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .center, spacing: 10) {
                        Text(stockTicker)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        Button(action: {
                            if vm.isStockSaved {
                                vm.deleteSavedStock(ticker: stockTicker)
                            } else {
                                vm.saveStock(ticker: stockTicker)
                            }
                        }) {
                            Image(systemName: vm.isStockSaved ? "star.fill": "star")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor( !vm.isStockSaved ? .white.opacity(0.85) : .yellow)
                                .frame(width: 32, height: 28)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color(hex: "1F2A34").opacity(0.6)))
                        }
                        .buttonStyle(.plain)
                    }

                    Text(details.companyFullName)
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

                        Text(changePercentString)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor((details.changeInDay >= 0 ? Color.greenAccent : Color.redAccent).opacity(0.9))
                    }
                }
            }

            Divider().background(Color(hex: "222A32").opacity(0.6))

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(details.marketCap)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Text("Market Cap")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "8F989E"))
                }

                Spacer()

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
                                .frame(width: progressWidth(for: Double(newsBuzzPercent)), height: 10)
                                .mask(Capsule())
                        }
                        .frame(width: 160, height: 10)

                        Text("\(newsBuzzPercent)%")
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

    private func progressWidth(for percent: Double) -> CGFloat {
        // maps percent (0..100) to width of capsule (160 is full width used above)
        let maxWidth: CGFloat = 160
        let safe = max(0, min(100, percent))
        return maxWidth * CGFloat(safe / 100.0)
    }
}

// MARK: Price Chart Card (kept modular)
struct PriceChartCard: View {
    let prices: [Double]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Price Chart (30 Days)")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 6)

            PriceChart(prices: prices)
                .frame(height: 220)
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.cardBorder, lineWidth: 1))
    }
}

struct PriceChart: View {
    let prices: [Double]
    /// Number of Y axis ticks shown on the left
    private let tickCount: Int = 5

    var body: some View {
        GeometryReader { outerGeo in
            HStack(spacing: 12) {
                // Chart area
                GeometryReader { geo in
                    ZStack {
                        Canvas { ctx, size in
                            guard prices.count > 1 else { return }

                            let w = size.width
                            let h = size.height
                            let minP = prices.min() ?? 0
                            let maxP = prices.max() ?? 1
                            let range = maxP - minP == 0 ? 1 : maxP - minP

                            func x(at idx: Int) -> CGFloat {
                                let step = w / CGFloat(max(1, prices.count - 1))
                                return CGFloat(idx) * step
                            }

                            func y(for price: Double) -> CGFloat {
                                let pct = CGFloat((price - minP) / range)
                                return h - (pct * h)
                            }

                            var path = Path()
                            path.move(to: CGPoint(x: x(at: 0), y: y(for: prices[0])))

                            for i in 1..<prices.count {
                                path.addLine(to: CGPoint(x: x(at: i), y: y(for: prices[i])))
                            }

                            let strokeStyle = StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round)
                            ctx.stroke(path, with: .color(Color.chartLine), style: strokeStyle)

                            // fill under curve
                            var fillPath = path
                            fillPath.addLine(to: CGPoint(x: x(at: prices.count - 1), y: h))
                            fillPath.addLine(to: CGPoint(x: x(at: 0), y: h))
                            fillPath.closeSubpath()

                            let gradient = Gradient(colors: [Color.chartFill.opacity(0.9), Color.chartFill.opacity(0.05)])
                            ctx.fill(fillPath, with: .linearGradient(gradient, startPoint: .zero, endPoint: CGPoint(x: 0, y: h)))
                        }
                        .drawingGroup()
                        .padding(.leading, 50)

                        // Overlay Y-axis tick labels positioned exactly using same conversion as Canvas
                        HStack {
                            VStack {
                                if let minP = prices.min(), let maxP = prices.max() {
                                    let range = maxP - minP == 0 ? 1 : maxP - minP

                                    ForEach(0..<tickCount, id: \.self) { i in
                                        let value = maxP - (Double(i) * (range / Double(max(1, tickCount - 1))))
                                        GeometryReader { labelGeo in
                                            let h = labelGeo.size.height
                                            let pct = CGFloat((value - minP) / range)
                                            let yPos = h - (pct * h)
                                            Text(value.formattedPrice)
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                                .position(x: -8, y: yPos)
                                        }
                                        .allowsHitTesting(false)
                                    }
                                }
                            }
                            .padding()
                            
                            Spacer()
                        }
                        .padding(.leading)
                    }
                }
            }
            // ensure the whole control uses the same height as requested by parent frame
            .frame(width: outerGeo.size.width, height: outerGeo.size.height)
        }
    }
}



// MARK: News Sentiment Card

struct NewsSentimentCard: View {
    let sentimentScores: SentimentCardModel

    private var counts: (bullish: Int, neutral: Int, bearish: Int) {
        (sentimentScores.bullish,
         sentimentScores.neutral,
         sentimentScores.bearish)
    }

    // Weighted ratio between 0.0 (fully bearish) and 1.0 (fully bullish).
    // neutral contributes halfway (0.5).
    private var scoreRatio: CGFloat {
        let b = counts.bullish
        let n = counts.neutral
        let r = counts.bearish
        let total = b + n + r
        guard total > 0 else { return 0.5 }
        let weighted = Double(b) * 1.0 + Double(n) * 0.5 + Double(r) * 0.0
        let ratio = weighted / Double(total)
        return CGFloat(max(0, min(1, ratio)))
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("News Sentiment")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(counts.bullish - counts.bearish) pts")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }

            // Bar + dynamic marker
            GeometryReader { geo in
                let barWidth = max(0, geo.size.width)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.redSent, Color.graySent, Color.greenSent]),
                            startPoint: .leading,
                            endPoint: .trailing)
                        )
                        .frame(height: 12)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.cardBorder, lineWidth: 1))

                    // marker centered on computed position
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 4, height: 18)
                        .cornerRadius(2)
                        .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 1)
                        .offset(x: clampMarkerOffset(barWidth: barWidth), y: -3)
                }
            }
            .frame(height: 18)
            .padding(.bottom, 6)

            HStack {
                VStack {
                    Text("\(counts.bearish)")
                        .font(.title3)
                        .foregroundColor(.red)
                    Text("Bearish Articles")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack {
                    Text("\(counts.neutral)")
                        .font(.title3)
                        .foregroundColor(.gray)
                    Text("Neutral Articles")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack {
                    Text("\(counts.bullish)")
                        .font(.title3)
                        .foregroundColor(.green)
                    Text("Bullish Articles")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.cardBorder, lineWidth: 1))
    }

    // Helper to compute offset and keep marker fully inside the bar
    private func clampMarkerOffset(barWidth: CGFloat) -> CGFloat {
        let markerWidth: CGFloat = 4
        let x = (barWidth * scoreRatio) - (markerWidth / 2)
        let minX: CGFloat = 0 - (markerWidth / 2) + 0 // allow tiny half-pixel, keep inside
        let maxX: CGFloat = barWidth - (markerWidth / 2)
        return min(max(x, minX), maxX)
    }
}


// MARK: Recent News

private struct RecentNewsList: View {
    let recentNews: [NewsModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent News (\(recentNews.count))")
                .foregroundColor(.white)
                .font(.headline)

            ForEach(Array(recentNews.enumerated()), id: \.offset) { _, item in
                NewsRow(title: item)
            }
        }
    }
}

private struct NewsRow: View {
    let title: NewsModel

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title.title)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .lineLimit(3)

                Text("") // placeholder for source/time if model extended later
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if let link = URL(string: title.link) {
                Link("Read", destination: link)
                    .foregroundColor(Color.blue)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.cardBackground))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.cardBorder, lineWidth: 1))
    }
}



//
//struct StockPageView_Previews: PreviewProvider {
//    static var previewModel: StockDetailsModel {
//        StockDetailsModel(
//            companyFullName: "Advanced Micro Devices",
//            price: 132.89,
//            changeInDay: 8.91,
//            marketCap: "215B",
//            volume: "82.3M",
//            newsBuzz: "91%",
//            pricesHistory: (0..<30).map { 120.0 + Double($0) * 0.5 },
//            newsSentiment: SentimentCardModel(bullish: 12, bearish: 12, neutral: 12),
//            recentNews: mockNews
//        )
//    }
//
//    static var previews: some View {
//        StockPageView(stockTicker: "AMD")
//            .frame(minWidth: 1000, minHeight: 400)
//    }
//}
