//
//  WatchlistsView.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 04/12/25.
//

import SwiftUI

struct WatchlistsView: View {
    @StateObject private var vm = WatchListViewModel()
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
    
    var body: some View {
        ScrollView(content: {
            VStack {
                
                Text("Saved Stocks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                LazyVGrid(columns: columns, content: {
                    ForEach(vm.savedStocks, id: \.self) { stock in
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
                    ForEach(vm.stocks, id: \.self.ticker) { stock in
                        StockRowView(stock: stock)
                            .padding()
                    }
                }
            }
        })
        .background(Color.csBackground)
        .navigationDestination(for: String.self) { ticker in
            StockPageView(stockTicker: ticker)
        }
        .task {
            await vm.getStocks()
        }
    }
}

#Preview {
    WatchlistsView()
}
