//
//  DummyNavigationButton.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-15.
//

import SwiftUI

struct DummyNavigationButton: View {
    let title : String
    let icon : String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.accent)
            
            if icon == nil {
                Text(title)
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
            } else {
                Label(title, systemImage: icon ?? "")
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
            }
        }
        .padding(.top)
        .frame(height: 65)
    }
}

#Preview {
    DummyNavigationButton(title: "Test", icon: nil)
}
