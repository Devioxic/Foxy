//
//  LibraryTopText.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-06.
//

import SwiftUI

struct NoPressEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct LibraryTopText: View {
    let itemText: String
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            if selected {
                Text(itemText)
                    .fontWeight(.bold)
                    .foregroundStyle(.foxySecondary)
            } else {
                Text(itemText)
                    .foregroundStyle(.foxySecondary)
            }
        }
        .buttonStyle(NoPressEffectButtonStyle())
    }
}
