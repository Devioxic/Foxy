//
//  Pills.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-27.
//

import SwiftUI

struct Pills: View {
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                MiniCard(title: "1989 (Taylor's Version)", text: "Taylor Swift", imageURL: "Foxies")
                MiniCard(title: "Lover", text: "Taylor Swift", imageURL: "Foxies")
            }
            HStack {
                MiniCard(title: "1989 (Taylor's Version)", text: "Taylor Swift", imageURL: "Foxies")
                MiniCard(title: "Lover", text: "Taylor Swift", imageURL: "Foxies")
            }
            HStack {
                MiniCard(title: "1989 (Taylor's Version)", text: "Taylor Swift", imageURL: "Foxies")
                MiniCard(title: "Lover", text: "Taylor Swift", imageURL: "Foxies")
            }
        }
    }
}

#Preview {
    Pills()
}
