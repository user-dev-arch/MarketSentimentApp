//
//  Color+.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 10/12/25.
//


import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
    
    
    static let cardBackground = Color(hex: "0F1720").opacity(0.9)
    static let cardBorder = Color(hex: "1F2A34").opacity(0.6)
    static let chartLine = Color(hex: "86D99B")
    static let chartFill = Color(hex: "86D99B")
    static let greenAccent = Color(hex: "2EE59A")
    static let redAccent = Color(hex: "FF6B6B")
    static let redSent = Color(hex: "7C2E2E")
    static let graySent = Color(hex: "4A5568")
    static let greenSent = Color(hex: "1F5F36")
}
