//
//  DashboardView.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 04/12/25.
//

import SwiftUI
import Foundation

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @StateObject private var watchlistVM = WatchListViewModel()
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]

    var body: some View {
        
        ScrollView {
            let horizontalPadding: CGFloat = 24
            let spacing: CGFloat = 20
            
            VStack(spacing: 20) {
                HStack(alignment: .top, spacing: spacing) {
                    PanelCard(title: "Top Movers", systemIcon: "chart.line.uptrend.xyaxis") {
                        ForEach(viewModel.topMovers.indices, id: \.self) { idx in
                            NavigationLink(value: viewModel.topMovers[idx].ticker) {
                                TopMoverRow(model: viewModel.topMovers[idx])
                                    .padding(.vertical, 8)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    PanelCard(title: "News Buzz", systemIcon: "antenna.radiowaves.left.and.right") {
                        ForEach(viewModel.newsBuzz.indices, id: \.self) { idx in
                            NavigationLink(value: viewModel.newsBuzz[idx].ticker) {
                                NewsBuzzRow(model: viewModel.newsBuzz[idx])
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    PanelCard(title: "Sentiment Movers", systemIcon: "bolt.circle") {
                        ForEach(viewModel.sentimentMovers.indices, id: \.self) { idx in
                            NavigationLink(value: viewModel.sentimentMovers[idx].ticker) {
                                SentimentMoverRow(model: viewModel.sentimentMovers[idx])
                                    .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 24)
                
                
                Text("Saved Stocks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                
                LazyVGrid(columns: columns, content: {
                    ForEach(watchlistVM.savedStocks, id: \.self) { stock in
                        NavigationLink(value: stock) {
                            WatchlistRowView(stockTicker: stock)
                        }
                        .buttonStyle(.plain)
                    }
                })
                .padding(.horizontal)
                
                Text("All Stocks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                VStack {
                    ForEach(viewModel.stocks, id: \.self.ticker) { stock in
                        StockRowView(stock: stock)
                            .padding()
                    }
                }
                
                
                Spacer(minLength: 40)
            }
            .frame(maxHeight: .infinity)
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigation) {
                Button {
                    watchlistVM.getSavedStocks()
                    Task {
                        await viewModel.getStocks()
                        await viewModel.getTopMovers()
                        await viewModel.getNewsBuzz()
                        await viewModel.getSentimentMovers()
                    }
                } label: {
                    Text("Refresh")
                }
            }
        })
        .onAppear(perform: {
            watchlistVM.getSavedStocks()
        })
        .background(Color(.csBackground))
        .task {
            await viewModel.getStocks()
            await viewModel.getTopMovers()
            await viewModel.getNewsBuzz()
            await viewModel.getSentimentMovers()
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Text("Market Sentiment")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(.sRGB, white: 0.12))
                    )
            }
        }
        .navigationDestination(for: String.self) { ticker in
            StockPageView(stockTicker: ticker)
        }
    }
}

// PanelCard now accepts systemIcon and shows icon + title
private struct PanelCard<Content: View>: View {
    var title: String
    var systemIcon: String
    let content: () -> Content

    init(title: String, systemIcon: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.systemIcon = systemIcon
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Label {
                    Text(title)
                        .font(.headline)
                } icon: {
                    Image(systemName: systemIcon)
                        .font(.system(size: 15, weight: .semibold))
                }
                .labelStyle(.titleAndIcon)
                Spacer()
            }

            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.sRGB, white: 0.06))
                .shadow(color: Color.black.opacity(0.45), radius: 8, x: 0, y: 6)
        )
    }
}

// --- Rows (unchanged logic, kept compact) ---
private struct TopMoverRow: View {
    let model: TopMoversModel
    private var changeColor: Color { Double(model.change) ?? 0 >= 0 ? .green : .red }
    private var changeText: String { String(format: "%+.2f%%", Double(model.change) ?? 0) }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(model.ticker).font(.headline)
                Text(String(format: "$%.2f", Double(model.currentPrice) ?? 0))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(changeText).font(.headline).foregroundColor(changeColor)
        }
    }
}

private struct NewsBuzzRow: View {
    let model: NewsBuzzModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.ticker).font(.headline)
                    Text(model.companyFullName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(width: 80, alignment: .leading)
                }
                
                ProgressBar(progress: CGFloat(Double(model.score) ?? 0))
                    .frame(height: 8)
                    .onAppear {
                        print(CGFloat(Double(model.score) ?? 0))
                    }
                
                Text(String(format: "%.0f%%", (Double(model.score) ?? 0) * 100)).font(.subheadline)
            }
        }
    }
}

private struct SentimentMoverRow: View {
    let model: SentimentMoversModel
    private var changeColor: Color { model.change >= 0 ? .green : .red }
    private var changeText: String { String(format: "%+.0f", model.change) }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.ticker).font(.headline)
                Text("Sentiment: \(model.sentimentScore)").font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                
                Text(changeText).font(.headline).foregroundColor(changeColor)
            }
        }
    }
}



// small if modifier helper
private extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition { transform(self) } else { self }
    }
}




#if DEBUG
// preview helpers with sample data
private extension DashboardViewModel {
    static func sample() -> DashboardViewModel {
        let vm = DashboardViewModel()
        vm.topMovers = PreviewModels.topMoversList
        vm.newsBuzz = PreviewModels.newsBuzzModels
        vm.sentimentMovers = PreviewModels.sentimentMoversModels
        return vm
    }
}

#endif

#Preview {
    DashboardView()
}
