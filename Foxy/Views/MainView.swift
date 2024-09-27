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
        if !viewModel.isSignedIn {
            WelcomeView()
        } else {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .toolbarBackground(Color.tabBarColor, for: .tabBar)
                    .toolbarBackground(.visible, for: ToolbarPlacement.tabBar)
            }
        }
    }
}

#Preview {
    MainView()
}
