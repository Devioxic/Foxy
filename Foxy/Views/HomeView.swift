//
//  HomeView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack(alignment: .center) {
                        MiniCard(title: "1989 (Taylor's Version)", text: "Taylor Swift", imageURL: "DevLogo")
                        MiniCard(title: "Lover", text: "Taylor Swift", imageURL: "DevLogo")
                    }
                    HStack {
                        MiniCard(title: "1989 (Taylor's Version)", text: "Taylor Swift", imageURL: "DevLogo")
                        MiniCard(title: "Lover", text: "Taylor Swift", imageURL: "DevLogo")
                    }
                    HStack {
                        MiniCard(title: "1989 (Taylor's Version)", text: "Taylor Swift", imageURL: "DevLogo")
                        MiniCard(title: "Lover", text: "Taylor Swift", imageURL: "DevLogo")
                    }
                }
                
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
