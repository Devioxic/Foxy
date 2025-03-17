//
//  Pills.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-27.
//

import SwiftUI

struct Pills: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var albums: [Album]
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    viewModel.addToPath(item: albums[0])
                }) {
                    MiniCard(title: albums[0].title, text: albums[0].artist, imageURL: albums[0].id, blurHash: albums[0].imageBlurHash)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    viewModel.addToPath(item: albums[1])
                }) {
                    MiniCard(title: albums[1].title, text: albums[1].artist, imageURL: albums[1].id, blurHash: albums[1].imageBlurHash)
                }
                .buttonStyle(.plain)
            }
            HStack {
                Button(action: {
                    viewModel.addToPath(item: albums[2])
                }) {
                    MiniCard(title: albums[2].title, text: albums[2].artist, imageURL: albums[2].id, blurHash: albums[2].imageBlurHash)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    viewModel.addToPath(item: albums[3])
                }) {
                    MiniCard(title: albums[3].title, text: albums[3].artist, imageURL: albums[3].id, blurHash: albums[3].imageBlurHash)
                }
                .buttonStyle(.plain)
            }
            HStack {
                Button(action: {
                    viewModel.addToPath(item: albums[4])
                }) {
                    MiniCard(title: albums[4].title, text: albums[4].artist, imageURL: albums[4].id, blurHash: albums[4].imageBlurHash)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    viewModel.addToPath(item: albums[5])
                }) {
                    MiniCard(title: albums[5].title, text: albums[5].artist, imageURL: albums[5].id, blurHash: albums[5].imageBlurHash)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
