//
//  MainView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-13.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        WelcomeView()
        
        if (false) {
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
