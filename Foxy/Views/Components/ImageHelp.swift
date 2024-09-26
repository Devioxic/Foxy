//
//  ImageHelp.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-24.
//

import SwiftUI

struct ImageHelp: View {
    let url : String
    let type : ContentMode
    
    var body: some View {
        if let u = URL(string: url) {
            AsyncImage(url: u) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: type)
            } placeholder: {
                Image("DevLogo")
            }
        } else {
            Image(url)
                .resizable()
                .aspectRatio(contentMode: type)
        }
    }
}

#Preview {
    ImageHelp(url : "DevLogo", type: .fit)
}
