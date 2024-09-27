//
//  MainViewModel.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-27.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    
    init() {
        if JellyfinMusicService.trySignIn() {
            print("Signed in")
            isSignedIn = true
        } else {
            print("Not signed in")
            isSignedIn = false
        }
        
        JellyfinMusicService.shared.$isSignedIn
            .assign(to: &$isSignedIn)
    }
    
    func retrieveMusicLibrary() -> Bool {
        Task {
            await JellyfinMusicService.shared.getRecentlyListened(amount: 10)
        }
        
        return true
    }
}
