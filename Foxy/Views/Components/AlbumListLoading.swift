//
//  AlbumListLoading.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-01.
//

import SwiftUI

struct AlbumListLoading: View {
    let title : String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            ForEach(0..<5) { _ in
                HStack(spacing: 20) {
                    AlbumLoading(isLarge: true)
                    AlbumLoading(isLarge: true)
                }
            }
        }
    }

}

#Preview {
    AlbumListLoading(title: "Test")
}
