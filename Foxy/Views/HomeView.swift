//
//  HomeView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.retrieveMusicLibrary() {
                    Spacer()
                }
                
                Pills()
                    .padding(.top, 20)
                    
                AlbumScroll(title: "Recently Added")
                    .padding(.top, 20)
                AlbumList(title: "Favourites")
                    .padding(.top, 20)

                Spacer()
            }
        }
        .background(Color.backgroundColor)
    }
}

#Preview {
    HomeView()
}
