//
//  MainViewModel.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-27.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var ready: Bool = false
    
    @MainActor
    init() {
        Task {
            isSignedIn = await JellyfinMusicService.trySignIn()
        
            JellyfinMusicService.shared.$isSignedIn
                .assign(to: &$isSignedIn)
            
            ready = true
        }
    }
}
