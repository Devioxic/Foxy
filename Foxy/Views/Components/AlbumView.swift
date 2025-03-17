//
//  AlbumView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-23.
//

import SwiftUI

struct AlbumView: View {
    let album: Album
    let showYearInsteadOfArtist: Bool
    let isLarge: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if isLarge {
                ImageHelp(imageID: album.id, blurHash: album.imageBlurHash)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 20, height: (UIScreen.main.bounds.width / 2) - 20)
                    .clipShape(.rect(cornerRadius: 10))
            } else {
                ImageHelp(imageID: album.id, blurHash: album.imageBlurHash)
                    .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
                    .clipShape(.rect(cornerRadius: 10))
                    
            }
            if isLarge {
                Text(album.title)
                    .padding(.top, 5)
                    .font(.title3)
                    .fontWeight(.regular)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 20, alignment: .leading)
                    .lineLimit(1)
            } else {
                Text(album.title)
                    .padding(.top, 5)
                    .font(.title3)
                    .fontWeight(.regular)
                    .frame(width: UIScreen.main.bounds.width / 2.5, alignment: .leading)
                    .lineLimit(1)
            }
                
            if !showYearInsteadOfArtist {
                Text(album.artist)
                    .foregroundColor(Color.secondaryText)
                    .lineLimit(1)
            } else {
                Text(album.year)
                    .foregroundColor(Color.secondaryText)
                    .lineLimit(1)
            }
                
        }
    }
}
