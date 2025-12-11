//
//  ContentView.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 02/12/25.
//

import SwiftUI

enum TabSelections {
    case dashboard, news, watchlist, alerts
    
    
    var title: String {
        switch self {
        case .dashboard:
            return "Dashboard"
        case .news:
            return "News"
        case .watchlist:
            return "Watchlist"
        case .alerts:
            return "Alerts"
        }
    }
    
    var icon: String {
        switch self {
        case .dashboard:
            return "house.fill"
        case .news:
            return "newspaper"
        case .watchlist:
            return "star"
        case .alerts:
            return "bell.and.waves.left.and.right.fill"
        }
    }
}


struct ContentView: View {
    @State private var tabSelection: TabSelections = .dashboard
    
    var body: some View {
        TabView(selection: $tabSelection) {
            tabs
        }
        .tabViewStyle(.automatic)
        .frame(minWidth: 800, minHeight: 300)
    }
    
    
    @TabContentBuilder<TabSelections>
    private var tabs: some TabContent<TabSelections> {
        dashboardTab
        newsTab
        WatchlistsTab
    }
    
    
    private var dashboardTab: some TabContent<TabSelections> {
        Tab(TabSelections.dashboard.title, image: TabSelections.dashboard.icon, value: .dashboard) {
            NavigationStack {
                DashboardView()
            }
        }
    }
    
    
    private var newsTab: some TabContent<TabSelections> {
        Tab(TabSelections.news.title, image: TabSelections.news.icon, value: .news) {
            NavigationStack {
                NewsView()
            }
        }
    }
    
    private var WatchlistsTab: some TabContent<TabSelections> {
        Tab(TabSelections.watchlist.title, image: TabSelections.watchlist.icon, value: .watchlist) {
            NavigationStack {
                WatchlistsView()
            }
        }
    }
    
    private var alertsTab: some TabContent<TabSelections> {
        Tab(TabSelections.alerts.title, image: TabSelections.alerts.icon, value: .alerts) {
            NavigationStack {
                AlertsView()
            }
        }
    }
    
}

#Preview {
    ContentView()
}
