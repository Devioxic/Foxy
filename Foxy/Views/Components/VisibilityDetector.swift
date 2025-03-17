//
//  VisibilityDetector.swift
//  Foxy
//
//  Created by Tilly Persson on 2025-03-03.
//

import SwiftUI

struct VisibilityDetector: View {
    let onVisible: () -> Void
    let onHidden: () -> Void
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onChange(of: geometry.frame(in: .global)) { newFrame, _ in
                    detectVisibility(frame: newFrame, force: false)
                }
                .onAppear() {
                    DispatchQueue.main.async {
                        detectVisibility(frame: geometry.frame(in: .global), force: true)
                    }
                }
        }
    }
    
    private func detectVisibility(frame: CGRect, force: Bool) {
        let screenBounds = UIScreen.main.bounds
        
        let isCurrentlyVisible = frame.intersects(screenBounds)
        
        if isCurrentlyVisible && (!isVisible || force) {
            
            isVisible = true
            onVisible()
        } else if !isCurrentlyVisible && (isVisible || force) {
            isVisible = false
            onHidden()
        }
    }
}


