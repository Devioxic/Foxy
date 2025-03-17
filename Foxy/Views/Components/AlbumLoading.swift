//
//  AlbumLoading.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-01.
//

import SwiftUI

struct AlbumLoading: View {
    let isLarge: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if isLarge {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: (UIScreen.main.bounds.width / 2) - 20, height: (UIScreen.main.bounds.width / 2) - 20)
                    .shimmering()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
                    .shimmering()
            }
            
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 150, height: 20)
                .padding(.top, 5)
                .shimmering()

            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 15)
                .shimmering()
        }
    }
}


#Preview {
    AlbumLoading(isLarge: true)
}
