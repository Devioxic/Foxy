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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.miniCardColor)
            HStack {
                Image(imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                
                Spacer()
                
                VStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.horizontal, 5)
                    Text(text)
                        .foregroundColor(Color.secondaryText)
                        .font(.callout)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal, 5)
                }
                
                Spacer()

            }
        }
        .frame(width: (UIScreen.main.bounds.width / 2) - 15, height: 60)
        
    }
}

#Preview {
    MiniCard(title: "Lover", text: "Taylor Swift", imageURL: "DevLogo")
}
