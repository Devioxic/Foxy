//
//  ImageCache.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-04.
//

import Foundation
import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 200
    }
    
    func getCachedImage(for id: String) -> UIImage? {
        return cache.object(forKey: NSString(string: id))
    }
    
    func cacheImage(_ image: UIImage, for id: String) {
        cache.setObject(image, forKey: NSString(string: id))
    }
}
