//
//  ArtistDetailView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-03.
//

import SwiftUI

struct ArtistDetailView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var topBarVisibility: Visibility = .hidden
    @State private var scrollOffset: CGFloat = 0
    @State private var albums: [Album]? = nil
    @State private var loadedArtist: Artist? = nil
    
    let artist: ArtistLoading
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
                        if loadedArtist == nil {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .shimmering()
                                .frame(width: UIScreen.main.bounds.width, height: max(UIScreen.main.bounds.width, UIScreen.main.bounds.width + scrollOffset))
                        } else {
                            ImageHelp(imageID: loadedArtist!.id, blurHash: loadedArtist!.blurHash)
                                .frame(width: UIScreen.main.bounds.width, height: max(UIScreen.main.bounds.width, UIScreen.main.bounds.width + scrollOffset))
                        }
                        
                        VStack {
                            Spacer()
                            
                            HStack{
                                Text(artist.name)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 30))
                                    .fontWeight(.semibold)
                                    .padding(20)
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                        }
                    }
                    
                    HStack(spacing: 20) {
                        PrimaryButton(title: "Play", icon: "play.fill") {
                            
                        }
                        PrimaryButton(title: "Shuffle", icon: "shuffle") {
                            
                        }
                    }
                    .frame(height: 70)
                    .padding(20)
                    .padding(.top, -30)
                    
                    if albums == nil {
                        AlbumListLoading(title: "Albums")
                    } else {
                        AlbumList(title: "Albums", albums: albums!, showYearInsteadOfArtist: true)
                            .padding(.horizontal, 20)
                    }
                }
                .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
            }
            .ignoresSafeArea(.container, edges: .top)
            .toolbar(topBarVisibility)
            .onAppear {
                Task {
                    loadedArtist = await viewModel.loadArtist(artistId: artist.id)
                    albums = await viewModel.getAlbumsFromIds(loadedArtist!.albumIds)
                }
                
                if scrollOffset <= treshold {
                    topBarVisibility = .visible
                } else {
                    topBarVisibility = .hidden
                }
            }
            .navigationTitle(Text(artist.name))
            
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
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
    }
}
