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
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.foxySecondary)
                
                if icon == nil {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                } else {
                    Label(title, systemImage: icon ?? "")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        
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
