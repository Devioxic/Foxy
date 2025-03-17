//
//  Album.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-28.
//

import Foundation

public struct Album: Hashable, Codable {
    let id: String
    let title: String
    let imageBlurHash: String?
    let year: String
    let premiereDate: Date
    let artist: String
    let artistId: String
    let tracks: [Track]
}
