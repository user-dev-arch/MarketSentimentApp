//
//  Double+.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 10/12/25.
//

import Foundation


extension Double {
    var formattedPrice: String {
        if abs(self) >= 1000 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            return "$" + (formatter.string(from: NSNumber(value: self)) ?? "\(self)")
        } else {
            return String(format: "$%.2f", self)
        }
    }
    
    
    var formatTwo: String {
        String(format: "%.2f", self)
    }

    var formattedCurrency: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
