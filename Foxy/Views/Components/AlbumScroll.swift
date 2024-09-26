//
//  AlbumScroll.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-23.
//

import SwiftUI

struct AlbumScroll: View {
    let title : String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Spacer()
                        .frame(width: 1)
                    ForEach(0..<50) { index in
                        Album(title: "Reputation", artist: "Taylor Swift", imageURL: "https://upload.wikimedia.org/wikipedia/en/f/f2/Taylor_Swift_-_Reputation.png", isLarge: false)
                    }
                }
            }
        }
    }
}

#Preview {
    AlbumScroll(title: "Test")
}
