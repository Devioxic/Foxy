//
//  ShimmeringEffect.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-01.
//

import Foundation
import SwiftUI

extension View {
    func shimmering() -> some View {
        self.overlay(
            ShimmerView()
                .mask(self)
        )
    }
}
