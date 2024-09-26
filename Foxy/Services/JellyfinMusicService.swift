//
//  JellyfinMusicService.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-26.
//

import Foundation
import JellyfinAPI
import UIKit

class JellyfinMusicService {
    static var shared: JellyfinMusicService!
    
    let client: JellyfinClient
    
    private init(url: String) {
        let newUrl = URL(string: url)!
        let configuration = JellyfinClient.Configuration(
            url: newUrl,
            client: "Foxy",
            deviceName: UIDevice.current.name,
            deviceID: UIDevice.current.identifierForVendor?.uuidString ?? "Unknown",
            version: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        )
        
        client = JellyfinClient(configuration: configuration)
    }
    
    static func initialize(url: String) {
        shared = JellyfinMusicService(url: url)
    }
}
