//
//  MiniCardPlaceholder.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-01.
//

import SwiftUI

struct MiniCardPlaceholder: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.gray.opacity(0.3))
            HStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .padding(5)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 15)
                        .padding(.horizontal, 5)
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 10)
                        .padding(.horizontal, 5)
                }
                
                Spacer()
            }
        }
        .frame(width: (UIScreen.main.bounds.width / 2) - 15, height: 60)
    }
}

#Preview {
    MiniCardPlaceholder()
}
