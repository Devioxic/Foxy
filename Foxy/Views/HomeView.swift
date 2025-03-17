//
//  HomeView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var jelly = JellyfinMusicService.shared
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
                ScrollView {
                    VStack {
                        if viewModel.isPillsEnabled {
                            if viewModel.ready {
                                Pills(albums: viewModel.pillAlbums)
                                    .environmentObject(viewModel)
                            } else {
                                LoadingPills()
                            }
                        }
                        
                        if viewModel.ready {
                            AlbumScroll(title: "Recently Added", albums: viewModel.recentlyAdded)
                                .padding(.top, 20)
                                .environmentObject(viewModel)
                        } else {
                            AlbumScrollLoading(title: "Recently Added")
                        }
                        
                        if viewModel.ready {
                            if viewModel.hasFavourites {
                                AlbumList(title: "Favourites", albums: viewModel.favouriteAlbums, showYearInsteadOfArtist: false)
                                    .padding(.top, 20)
                                    .environmentObject(viewModel)
                            } else {
                                VStack {
                                    HStack {
                                        Text("Favourites")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                        Spacer()
                                    }
                                    Image(systemName: "star.slash")
                                        .font(.system(size: 100, weight: .thin))
                                        .foregroundColor(.secondary)
                                        .padding(.top, 10)
                                    Text("No Favourites")
                                        .font(.system(size: 32, weight: .light))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 10)
                            }
                        } else {
                            AlbumListLoading(title: "Favourites")
                        }
                        
                        Spacer()
                    }
                }
                .padding(.top, 1)
                .background(Color.backgroundColor)
                .navigationDestination(for: Album.self) { album in
                    AlbumDetailView(album: album)
                        .environmentObject(viewModel)
                }
                .navigationDestination(for: ArtistLoading.self) { artist in
                    ArtistDetailView(artist: artist)
                        .environmentObject(viewModel)
                }
        }
        .safeAreaInset(edge: .bottom) {
            NowPlayingView()
        }
    }
}
