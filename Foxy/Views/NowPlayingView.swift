//
//  NowPlayingView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-24.
//

import SwiftUI

struct NowPlayingView: View {
    @StateObject private var jelly = JellyfinMusicService.shared
    
    @State private var trackLength: Double = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThickMaterial)
            
            
            HStack {
                ImageHelp(imageID: jelly.nowPlayingImageId ?? "nowPlayingError", blurHash: jelly.nowPlayingBlurHash)
                    .cornerRadius(10)
                    .frame(width: 45, height: 45)
                    .padding(.horizontal, 8)
                
                VStack(alignment: .leading) {
                    Text(jelly.nowPlayingTrack?.title ?? "")
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(jelly.nowPlayingTrack?.artist ?? "")
                        .font(.subheadline)
                        .lineLimit(1)
                }
                
                Spacer(minLength: 5)
                
                Image(systemName: "plus.square.fill.on.square.fill")
                    .font(.title2)
                Image(systemName: "pause.fill")
                    .font(.title2)
                    .padding(.trailing, 8)
            }
            
            VStack {
                Spacer()
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.backgroundColor)
                        .frame(height: 3)
                        .padding(.horizontal, 10)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.accentColor)
                        .frame(width: trackLength * (UIScreen.main.bounds.width  - 20), height: 2)
                        .padding(.horizontal, 10)
                }
                .onChange(of: jelly.currentTime) {
                    trackLength = jelly.currentTime / jelly.duration
                }
            }
        }
        .frame(height: 60)
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
        .offset(y: !jelly.isPlaying ? 200 : 0)
    }
}
