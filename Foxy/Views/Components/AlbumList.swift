//
//  AlbumList.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-24.
//

import SwiftUI

struct AlbumList: View {
    let title : String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            ForEach(0..<5) { _ in
                HStack(spacing: 20) {
                    Album(title: "Reputation", artist: "Taylor Swift", imageURL: "https://upload.wikimedia.org/wikipedia/en/f/f2/Taylor_Swift_-_Reputation.png", isLarge: true)
                    Album(title: "Reputation", artist: "Taylor Swift", imageURL: "https://upload.wikimedia.org/wikipedia/en/f/f2/Taylor_Swift_-_Reputation.png", isLarge: true)
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        AlbumList(title: "Favourites")
    }
}
