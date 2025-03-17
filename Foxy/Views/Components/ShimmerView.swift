//
//  ShimmerView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-01.
//

import SwiftUI

struct ShimmerView: View {
    @State private var phase: CGFloat = -1.0

    var body: some View {
        GeometryReader { geometry in
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.6), Color.clear]),
                           startPoint: .leading,
                           endPoint: .trailing)
                .scaleEffect(x: 2, y: 1, anchor: .center)
                .offset(x: phase * geometry.size.width)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        phase = 1.5
                    }
                }
        }
    }
}

#Preview {
    ShimmerView()
}
