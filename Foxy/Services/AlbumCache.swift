//
//  AlbumCache.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-04.
//

import Foundation

class AlbumWrapper: NSObject {
    let album: Album
    
    init(album: Album) {
        self.album = album
    }
}

class AlbumCache {
    static let shared = AlbumCache()
    private let cache = NSCache<NSString, AlbumWrapper>()
    
    private init() {
        cache.countLimit = 500
    }
    
    func cacheAlbum(_ album: Album) {
        let key = NSString(string: album.id)
        cache.setObject(AlbumWrapper(album: album), forKey: key)
    }
    
    func getAlbum(_ id: String) -> Album? {
        guard let wrapper = cache.object(forKey: NSString(string: id)) else { return nil }
        return wrapper.album
    }
}
