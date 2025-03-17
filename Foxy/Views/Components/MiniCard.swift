//
//  MiniCard.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-23.
//

import SwiftUI

struct MiniCard: View {
    let title : String
    let text : String
    let imageURL : String
    let blurHash : String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.miniCardColor)
            HStack {
                ImageHelp(imageID: imageURL, blurHash: blurHash)
                    .frame(width: 45, height: 45)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.vertical, 5)
                    .padding(.leading, 5)
                
                Spacer()
                
                VStack {
                    HStack {
                        Text(title)
                            .fontWeight(.regular)
                            .padding(.horizontal, 5)
                        Spacer()
                    }
                    HStack {
                        Text(text)
                            .foregroundColor(Color.secondaryText)
                            .font(.callout)
                            .padding(.horizontal, 5)
                        Spacer()
                    }
                }
                
                Spacer()

            }
        }
        .frame(width: (UIScreen.main.bounds.width / 2) - 15, height: 60)
        
    }
}
