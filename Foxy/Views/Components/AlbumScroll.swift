//
//  AlbumScroll.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-23.
//

import SwiftUI

struct AlbumScroll: View {
    @EnvironmentObject var viewModel: HomeViewModel
    let title: String
    let albums: [Album]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Spacer()
                        .frame(width: 1)
                    ForEach(albums, id: \.id) { album in
                        Button(action: {
                            viewModel.addToPath(item: album)
                        }, label: {
                            AlbumView(album: album, showYearInsteadOfArtist: false, isLarge: false)
                        })
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
