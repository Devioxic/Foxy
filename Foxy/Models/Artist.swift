//
//  Artist.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-28.
//

import Foundation

struct Artist: Hashable, Codable {
    let id: String
    let name: String
    let blurHash: String?
    let albumIds: [String]
}
