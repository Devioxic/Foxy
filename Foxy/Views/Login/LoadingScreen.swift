//
//  LoadingScreen.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-30.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("Foxies")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: geometry.size.width / 1.75)
                    .padding(.top, geometry.size.height / 20)
                
                Text("Initializing...")
                    .font(.title)
                    .padding(.top, 20)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .padding(.top, 20)
                
                Spacer()

            }
            .frame(width: geometry.size.width)
            
        }
    }
}

#Preview {
    LoadingScreen()
}
