//
//  LoadingPills.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-01.
//

import SwiftUI

struct LoadingPills: View {
    var body: some View {
        VStack {
            HStack {
                MiniCardPlaceholder()
                MiniCardPlaceholder()
            }
            HStack {
                MiniCardPlaceholder()
                MiniCardPlaceholder()
            }
            HStack {
                MiniCardPlaceholder()
                MiniCardPlaceholder()
            }
        }
        .redacted(reason: .placeholder)
        .shimmering()
    }
}

#Preview {
    LoadingPills()
}
