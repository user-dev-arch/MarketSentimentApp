//
//  ProgressBar.swift
//  MarketSentimentApp
//
//  Created by Muhammadjon Madaminov on 05/12/25.
//

import SwiftUI


struct ProgressBar: View {
    var progress: CGFloat // 0..1
    
    var body: some View {
        GeometryReader { geo in
            let w = max(0, min(1, progress)) * geo.size.width
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.sRGB, white: 0.12, opacity: 1))
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.sRGB, red: 1, green: 0.6, blue: 0.0, opacity: 1))
                    .frame(width: w)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
