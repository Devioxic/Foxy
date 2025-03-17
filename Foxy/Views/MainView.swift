//
//  MainView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-13.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        if !viewModel.ready {
            LoadingScreen()
        } else if !viewModel.isSignedIn {
            WelcomeView()
        } else {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                
                LibraryView()
                    .tabItem {
                        Image(systemName: "music.note")
                        Text("Library")
                    }
                
                DownloadsView()
                    .tabItem {
                        Image(systemName: "arrow.down.circle")
                        Text("Downloads")
                    }
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .toolbarBackground(.ultraThickMaterial, for: .tabBar)
                    .toolbarBackground(.visible, for: ToolbarPlacement.tabBar)
            }
        }
    }
}
