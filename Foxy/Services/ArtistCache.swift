//
//  ArtistCache.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-04.
//

import Foundation

class ArtistWrapper: NSObject {
    let artist: Artist
    
    init(artist: Artist) {
        self.artist = artist
    }
}

class ArtistCache {
    static let shared = ArtistCache()
    private let cache = NSCache<NSString, ArtistWrapper>()
    
    private init() {
        cache.countLimit = 100
    }
    
    func cacheArtist(_ artist: Artist) {
        let key = NSString(string: artist.id)
        cache.setObject(ArtistWrapper(artist: artist), forKey: key)
    }
    
    func getArtist(_ id: String) -> Artist? {
        guard let wrapper = cache.object(forKey: NSString(string: id)) else { return nil }
        return wrapper.artist
    }
}
