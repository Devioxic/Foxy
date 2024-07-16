//
//  PrimaryButton.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-13.
//

import SwiftUI

struct PrimaryButton: View {
    let title : String
    let icon : String?
    let action : () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.primaryColor)
                
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
        }
    }
}

#Preview {
    PrimaryButton(title: "Test", icon: "play.fill") {
        
    }
}
