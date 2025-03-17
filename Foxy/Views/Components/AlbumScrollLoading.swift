//
//  AlbumScrollLoading.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-01.
//

import SwiftUI

struct AlbumScrollLoading: View {
    let title : String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Spacer()
                        .frame(width: 1)
                    ForEach(0..<10) { index in
                        AlbumLoading(isLarge: false)
                    }
                }
            }
        }
    }
}

#Preview {
    AlbumScrollLoading(title: "Test")
}
