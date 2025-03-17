//
//  Track.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-28.
//

import Foundation

public struct Track: Hashable, Codable, Sendable {
    let id: String
    let title: String
    let duration: Int
    let artist: String
    let artistId: String
    let albumId: String
    let hasLyrics: Bool
    var isDownloaded: Bool
}
