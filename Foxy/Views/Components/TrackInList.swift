//
//  TrackInList.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-03.
//

import SwiftUI

struct TrackInList: View {
    let track: Track
    let index: Int
    
    var body: some View {
        HStack {
            Text(String(index + 1))
                .foregroundStyle(Color.secondaryText)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading) {
                Text(track.title)
                    .lineLimit(1)
                
                Text(track.artist)
                    .foregroundStyle(Color.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: {
                
            }) {
                Image(systemName: "plus.square.fill.on.square.fill")
                    .foregroundStyle(.foxy)
            }
            .padding(.horizontal, 20)
        }
    }
}
