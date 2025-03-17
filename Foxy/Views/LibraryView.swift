//
//  LibraryView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-01.
//

import SwiftUI

struct LibraryView: View {
    @State var currentlySelected: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    Spacer()
                }
                .background(Color.backgroundColor)
                
                VStack {
                    HStack {
                        Spacer()
                        LibraryTopText(itemText: "Albums", selected: currentlySelected == 0, action: { currentlySelected = 0 })
                        Spacer()
                        LibraryTopText(itemText: "Songs", selected: currentlySelected == 1, action: { currentlySelected = 1 })
                        Spacer()
                        LibraryTopText(itemText: "Artists", selected: currentlySelected == 2, action: { currentlySelected = 2 })
                        Spacer()
                        LibraryTopText(itemText: "Playlists", selected: currentlySelected == 3, action: { currentlySelected = 3 })
                        Spacer()
                    }
                    
                    ScrollView {
                        
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}
