//
//  SignInFirst.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-13.
//

import SwiftUI

struct SignInFirst: View {
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("DevLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: geometry.size.width / 1.75)
                    .padding(.top, geometry.size.height / 20)
                Text("Sign in")
                    .padding(.top, 50)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Form {
                    TextField("jellyfin.example.org")
                }
                
                Spacer()
                NavigationButton(title: "Get Started", icon: nil, destination: SignInFirst())
                .frame(height: 65)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .frame(width: geometry.size.width)
            
        }
    }
}

#Preview {
    SignInFirst()
}
