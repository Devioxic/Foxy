//
//  Album.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-23.
//

import SwiftUI

struct Album: View {
    let title : String
    let artist : String
    let imageURL : String
    let isLarge : Bool
    var body: some View {
        VStack(alignment: .leading) {
            if isLarge {
                AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image("DevLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: (UIScreen.main.bounds.width / 2) - 20)
                .clipShape(.rect(cornerRadius: 10))
            } else {
                AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image("DevLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: UIScreen.main.bounds.width / 2.5)
                .clipShape(.rect(cornerRadius: 10))
                    
            }
            Text(title)
                .padding(.top, 5)
                .font(.title2)
                .fontWeight(.medium)
            Text(artist)
                .foregroundColor(Color.secondaryText)
                
        }
    }
}

#Preview {
    Album(title: "Reputation", artist: "Taylor Swift", imageURL: "https://upload.wikimedia.org/wikipedia/en/f/f2/Taylor_Swift_-_Reputation.png", isLarge: false)
}
