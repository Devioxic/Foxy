//
//  AlbumList.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-24.
//

import SwiftUI

struct AlbumList: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    let title: String
    var albums: [Album]
    let showYearInsteadOfArtist: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            
            ForEach(0..<albums.count / 2 + albums.count % 2, id: \.self) { index in
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.addToPath(item: albums[index * 2])
                    }) {
                        AlbumView(album: albums[index * 2], showYearInsteadOfArtist: showYearInsteadOfArtist, isLarge: true)
                    }
                    .buttonStyle(.plain)
                    
                    // Check if the next album exists before accessing it
                    if (index * 2 + 1) < albums.count {
                        Button(action: {
                            viewModel.addToPath(item: albums[index * 2 + 1])
                        }) {
                            AlbumView(album: albums[index * 2 + 1], showYearInsteadOfArtist: showYearInsteadOfArtist, isLarge: true)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

