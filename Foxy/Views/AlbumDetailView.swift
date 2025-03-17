//
//  AlbumDetailView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-01.
//

import SwiftUI

struct AlbumDetailView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @StateObject var jelly = JellyfinMusicService.shared
    
    @State private var topBarVisibility: Visibility = .hidden
    @State private var scrollOffset: CGFloat = 0
    
    let album: Album
    private let treshold: CGFloat = -UIScreen.main.bounds.width + 90
    
    var body: some View {
        ZStack {
            ScrollView {
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            topBarVisibility = .hidden
                        }
                        .onChange(of: geometry.frame(in: .global).minY) { oldValue, newValue in
                            if newValue <= treshold {
                                topBarVisibility = .visible
                            } else {
                                topBarVisibility = .hidden
                            }
                            
                            scrollOffset = newValue
                        }
                }
                .frame(height: 0)
                VStack {
                    ZStack {
                        ImageHelp(imageID: album.id, blurHash: album.imageBlurHash)
                            .frame(width: UIScreen.main.bounds.width, height: max(UIScreen.main.bounds.width, UIScreen.main.bounds.width + scrollOffset))
                        
                        VStack {
                            Spacer()
                            
                            HStack{
                                Text(album.title)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 25))
                                    .fontWeight(.semibold)
                                    .padding(10)
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                        }
                    }
                                        
                    HStack(spacing: 10) {
                        PrimaryButton(title: "Play", icon: "play.fill") {
                            jelly.clearQueue()
                            jelly.addAlbumToQueue(album: album, manual: false)
                            jelly.play()
                        }
                        PrimaryButton(title: "Shuffle", icon: "shuffle") {
                            jelly.clearQueue()
                            jelly.addAlbumToQueue(album: album, manual: false)
                            jelly.shuffleQueue()
                            jelly.play()
                        }
                    }
                    .frame(height: 65)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                    
                    ForEach(album.tracks.indices, id: \.self) { index in
                        TrackInList(track: album.tracks[index], index: index)
                            .padding(.bottom, 10)
                    }
                }
                .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
            }
            .ignoresSafeArea(.container, edges: .top)
            .toolbar(topBarVisibility)
            .onAppear {
                if scrollOffset <= treshold {
                    topBarVisibility = .visible
                } else {
                    topBarVisibility = .hidden
                }
            }
            .navigationTitle(Text(album.title))
            .toolbar {
                Menu {
                    Button("Go to artist") {
                        viewModel.addArtistToPath(artistId: album.artistId, artistName: album.artist)
                    }
                    Button("Add to favourites") {
                        
                    }
                    Button("Download") {
                        
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .fontWeight(.bold)
                }
            }
            
            if topBarVisibility == .hidden {
                VStack {
                    HStack {
                        Button(action: {
                            viewModel.removeLastItem()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                                    .frame(width: 30, height: 30)
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        Spacer()
                        
                        Menu {
                            Button("Go to artist") {
                                viewModel.addArtistToPath(artistId: album.artistId, artistName: album.artist)
                            }
                            Button("Add to favourites") {
                                
                            }
                            Button("Download") {
                                
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                                    .frame(width: 30, height: 30)
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
    }
}
