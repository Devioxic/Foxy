//
//  HomeViewModel.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-01.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var ready: Bool = false
    
    @Published var isPillsEnabled: Bool = true
    @Published var pillAlbums: [Album] = []
    
    @Published var recentlyAdded: [Album] = []
    
    @Published var hasFavourites: Bool = false
    @Published var favouriteAlbums: [Album] = []
    
    private var lastAdded: (any Hashable)? = nil
    
    init() {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    let recentlyListened = await JellyfinMusicService.shared.getRecentlyPlayed()
                    DispatchQueue.main.async {
                        if let recentlyListened = recentlyListened, recentlyListened.count == 6 {
                            self.isPillsEnabled = true
                            self.pillAlbums = recentlyListened
                        } else {
                            self.isPillsEnabled = false
                        }
                    }
                }
                
                group.addTask {
                    let recentlyAdded = await JellyfinMusicService.shared.getRecentlyAdded(amount: 15)
                    DispatchQueue.main.async {
                        if let recentlyAdded = recentlyAdded {
                            self.recentlyAdded = recentlyAdded
                        }
                    }
                }
                
                group.addTask {
                    let hasFavourites = await JellyfinMusicService.shared.getFavoriteAlbums()
                    DispatchQueue.main.async {
                        if let hasFavourites = hasFavourites, hasFavourites.count > 0 {
                            self.hasFavourites = true
                            self.favouriteAlbums = hasFavourites
                        }
                    }
                }
                
                await group.waitForAll()
                
                DispatchQueue.main.async {
                    self.ready = true
                }
                
                await sync()
            }
        }
    }
    
    func sync() async {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    await JellyfinMusicService.shared.syncAllAlbums()
                }
                group.addTask {
                    await JellyfinMusicService.shared.syncAllArtists()
                }
            }
        }
    }
    
    func addToPath(item: any Hashable) {
        lastAdded = item
        navigationPath.append(item)
    }
    
    @MainActor
    func addArtistToPath(artistId: String, artistName: String) {
        let loadingArtist = ArtistLoading(name: artistName, id: artistId)
        self.navigationPath.append(loadingArtist)
    }
    
    func removeLastItem() {
        lastAdded = nil
        navigationPath.removeLast()
    }
    
    func loadArtist(artistId: String) async -> Artist? {
        return await JellyfinMusicService.shared.getArtistById(id: artistId)
    }
    
    func getAlbumsFromIds(_ albumIds: [String]) async -> [Album]? {
        print("Getting albums")
        
        guard let albums = await JellyfinMusicService.shared.getAlbumsFromIds(ids: albumIds) else { return nil}
        
        let sortedAlbums = albums.sorted { $0.premiereDate > $1.premiereDate }
    
        print("Got albums")
        return sortedAlbums
    }
}
